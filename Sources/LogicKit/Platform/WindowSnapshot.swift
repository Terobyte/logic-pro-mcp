import AppKit
import CoreGraphics

public struct CGWindowRecord: Codable, Hashable, Sendable {
    public var number: Int
    public var name: String?
    public var layer: Int
    public var onScreen: Bool
    public var ownerPID: Int32

    public init(number: Int, name: String?, layer: Int, onScreen: Bool, ownerPID: Int32) {
        self.number = number; self.name = name; self.layer = layer; self.onScreen = onScreen; self.ownerPID = ownerPID
    }
}

/// Spec §5.4. Logic lives on another Space and AXWindows is often empty, so Logic's windows come from
/// CGWindowList(.optionAll) filtered by PID; the user side comes from on-screen windows of the user's Space.
/// Only layer-0 windows count (tooltips/menus live on higher layers) — S1 confirms this filter.
public struct WindowSnapshot: Codable, Equatable, Sendable {
    public var logicWindows: [CGWindowRecord]
    public var mainWindowTitle: String?
    public var mainWindowSubrole: String?
    public var focusedWindowTitle: String?
    public var userFrontmostBundleID: String?
    public var userOnScreenWindowNumbers: [Int]

    public init(logicWindows: [CGWindowRecord], mainWindowTitle: String?, mainWindowSubrole: String?,
                focusedWindowTitle: String?, userFrontmostBundleID: String?, userOnScreenWindowNumbers: [Int]) {
        self.logicWindows = logicWindows; self.mainWindowTitle = mainWindowTitle
        self.mainWindowSubrole = mainWindowSubrole; self.focusedWindowTitle = focusedWindowTitle
        self.userFrontmostBundleID = userFrontmostBundleID; self.userOnScreenWindowNumbers = userOnScreenWindowNumbers
    }

    public static func records(from list: [[String: Any]]) -> [CGWindowRecord] {
        list.compactMap { d in
            guard let n = d[kCGWindowNumber as String] as? Int,
                  let pid = d[kCGWindowOwnerPID as String] as? Int32 else { return nil }
            return CGWindowRecord(number: n, name: d[kCGWindowName as String] as? String,
                                  layer: d[kCGWindowLayer as String] as? Int ?? 0,
                                  onScreen: d[kCGWindowIsOnscreen as String] as? Bool ?? false,
                                  ownerPID: pid)
        }
    }

    public static func assemble(all: [CGWindowRecord], onScreen: [CGWindowRecord], logicPID: pid_t,
                                main: AXAttrs?, focused: AXAttrs?, frontmostBundleID: String?) -> WindowSnapshot {
        WindowSnapshot(
            logicWindows: all.filter { $0.ownerPID == logicPID && $0.layer == 0 }.sorted { $0.number < $1.number },
            mainWindowTitle: main?.title, mainWindowSubrole: main?.subrole,
            focusedWindowTitle: focused?.title, userFrontmostBundleID: frontmostBundleID,
            userOnScreenWindowNumbers: onScreen.filter { $0.ownerPID != logicPID && $0.layer == 0 }.map(\.number).sorted())
    }

    /// Live capture. Reads AXMainWindow/AXFocusedWindow, so call it where AX calls are allowed.
    public static func capture(logicPID: pid_t, root: any AXRoot) throws -> WindowSnapshot {
        let all = records(from: CGWindowListCopyWindowInfo([.optionAll], kCGNullWindowID) as? [[String: Any]] ?? [])
        let on = records(from: CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? [])
        return assemble(all: all, onScreen: on, logicPID: logicPID,
                        main: try root.mainWindow()?.attrs(), focused: try root.focusedWindow()?.attrs(),
                        frontmostBundleID: NSWorkspace.shared.frontmostApplication?.bundleIdentifier)
    }

    public func diff(to after: WindowSnapshot) -> WindowDiff {
        let before = Set(logicWindows.map(\.number))
        let now = Set(after.logicWindows.map(\.number))
        let userBefore = Set(userOnScreenWindowNumbers)
        let userAfter = Set(after.userOnScreenWindowNumbers)
        return WindowDiff(
            newLogicWindows: after.logicWindows.filter { !before.contains($0.number) },
            closedLogicWindows: logicWindows.filter { !now.contains($0.number) },
            mainWindowChanged: mainWindowTitle != after.mainWindowTitle || mainWindowSubrole != after.mainWindowSubrole,
            userFrontmostChanged: userFrontmostBundleID != after.userFrontmostBundleID,
            // Heuristic: the user's on-screen windows were fully replaced → their Space changed.
            userSpaceChanged: !userBefore.isEmpty && !userAfter.isEmpty && userBefore.isDisjoint(with: userAfter))
    }
}

public struct WindowDiff: Equatable, Sendable {
    public var newLogicWindows: [CGWindowRecord]
    public var closedLogicWindows: [CGWindowRecord]
    public var mainWindowChanged: Bool
    public var userFrontmostChanged: Bool
    public var userSpaceChanged: Bool

    public var isClean: Bool {
        newLogicWindows.isEmpty && closedLogicWindows.isEmpty && !mainWindowChanged && !userFrontmostChanged && !userSpaceChanged
    }

    public var summary: String {
        var parts: [String] = []
        parts += newLogicWindows.map { "new logic window \($0.number) \($0.name ?? "")" }
        parts += closedLogicWindows.map { "closed logic window \($0.number) \($0.name ?? "")" }
        if mainWindowChanged { parts.append("main window changed") }
        if userFrontmostChanged { parts.append("user frontmost app changed") }
        if userSpaceChanged { parts.append("user space changed") }
        return parts.isEmpty ? "clean" : parts.joined(separator: "; ")
    }
}
