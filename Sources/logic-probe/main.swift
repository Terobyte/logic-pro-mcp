import ApplicationServices
import Foundation
import LogicKit

func err(_ s: String) { FileHandle.standardError.write(Data((s + "\n").utf8)) }
func fail(_ s: String, code: Int32 = 1) -> Never { err(s); exit(code) }

let usage = """
usage: logic-probe <command> [args] [--root main|menubar|focused|app] [--timeout 1]
 read-only:
  tree [--at LOC] [--depth 3]      subtree, one compactLine per node
  find LOC                         all matches of LOC's last step, with [index]
  attrs LOC                        compactLine + all attribute names
  raw LOC NAME                     any attribute (AXFrame, AXPosition, AXDocument…)
  windows                          WindowSnapshot JSON
  stats [--depth 40]               capture: nodes, ms, AX messages, timeouts
  menu PATH                        "Edit>^Undo": print the item (no press)
  observe [--at LOC] [--for 10] [--notifications a,b]
 mutating (only when the main window is a fixture- project):
  press LOC · set LOC TEXT · setnum LOC NUMBER · setbool LOC ATTR true|false
  inc LOC [N] · dec LOC [N] · menu PATH --press · action LOC AXName
  mmc play|stop|locate HH:MM:SS:FF · cc CHANNEL CONTROLLER VALUE
LOC: steps joined by " > "; step = key OP value;…[N]; keys role subrole title desc help id value; OP = ^= ~=
"""

var args = Array(CommandLine.arguments.dropFirst())
guard !args.isEmpty else { fail(usage, code: 2) }
let cmd = args.removeFirst()

@MainActor
func option(_ name: String) -> String? {
    guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
    let v = args[i + 1]
    args.removeSubrange(i...(i + 1))
    return v
}
@MainActor
func flag(_ name: String) -> Bool {
    guard let i = args.firstIndex(of: name) else { return false }
    args.remove(at: i)
    return true
}
@MainActor
func arg(_ i: Int) -> String {
    guard i < args.count else { fail(usage, code: 2) }
    return args[i]
}

guard LogicApp.axTrusted else { fail("Accessibility is not granted to this terminal") }
guard let pid = LogicApp.pid else { fail("Logic Pro is not running") }
let rootName = option("--root")
let root = LiveAXRoot(pid: pid, timeout: Float(option("--timeout") ?? "") ?? 1.0)

func base() throws -> any AXNode {
    switch rootName ?? "main" {
    case "main": guard let n = try root.mainWindow() else { fail("no main window") }; return n
    case "menubar": guard let n = try root.menuBar() else { fail("no menu bar") }; return n
    case "focused": guard let n = try root.focusedWindow() else { fail("no focused window") }; return n
    case "app": return root.appNode
    default: fail("unknown root \(rootName ?? "")", code: 2)
    }
}
func locate(_ loc: String) throws -> LiveAXNode {
    guard let n = try AXLocator.parse(loc).resolve(from: try base()) as? LiveAXNode else { fail("not found: \(loc)") }
    return n
}
func requireFixture() throws {
    let title = try root.mainWindow()?.attrs().title
    guard FixtureGuard.allows(mainWindowTitle: title) else {
        fail("refusing to mutate: main window is \(title ?? "nil"), expected a fixture- project")
    }
}
func ms(_ t0: Date) -> Int { Int(Date().timeIntervalSince(t0) * 1000) }
func shown(_ n: any AXNode) -> String? {
    guard let a = try? n.attrs() else { return "<gone>" }
    return a.valueDescription ?? a.value?.stringValue
}
/// Polls every 10 ms until the displayed value differs from `old` (or 1 s passes).
func waitChange(_ n: any AXNode, from old: String?) -> (String?, Int) {
    let t0 = Date()
    while Date().timeIntervalSince(t0) < 1.0 {
        let now = shown(n)
        if now != old { return (now, ms(t0)) }
        Thread.sleep(forTimeInterval: 0.01)
    }
    return (old, ms(t0))
}
func printTree(_ n: any AXNode, depth: Int, indent: Int = 0) throws {
    print(String(repeating: "  ", count: indent) + (try n.attrs().compactLine))
    guard depth > 0 else { return }
    for c in try n.children() { try printTree(c, depth: depth - 1, indent: indent + 1) }
}

do {
    switch cmd {
    case "tree":
        let depth = Int(option("--depth") ?? "") ?? 3
        let node: any AXNode = try option("--at").map { try locate($0) } ?? (try base())
        try printTree(node, depth: depth)
    case "find":
        let hits = try AXLocator.parse(arg(0)).resolveAll(from: try base())
        for (i, h) in hits.enumerated() { print("[\(i)] " + (try h.attrs().compactLine)) }
        print("matches: \(hits.count)")
    case "attrs":
        let n = try locate(arg(0))
        print(try n.attrs().compactLine)
        print("attributes: " + (try n.attributeNames()).joined(separator: ", "))
    case "raw":
        print(try locate(arg(0)).rawAttribute(arg(1)) ?? "<none>")
    case "windows":
        let e = JSONEncoder()
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        print(String(decoding: try e.encode(try WindowSnapshot.capture(logicPID: pid, root: root)), as: UTF8.self))
    case "stats":
        let depth = Int(option("--depth") ?? "") ?? 40
        AXStats.shared.reset()
        var s = CaptureStats()
        let t0 = Date()
        _ = try AXCapture.capture(try base(), depth: depth, stats: &s)
        print("nodes=\(s.nodes) truncated=\(s.truncatedAt) skipped=\(s.skipped) ax_messages=\(AXStats.shared.messages) timeouts=\(AXStats.shared.timeouts) ms=\(ms(t0))")
    case "menu":
        let press = flag("--press")
        guard let bar = try root.menuBar(),
              let item = try MenuPath.resolve(menuBar: bar, path: MenuPath.split(arg(0))) else { fail("menu not found: \(arg(0))") }
        print(try item.attrs().compactLine)
        if press {
            try requireFixture()
            let t0 = Date()
            try item.perform("AXPress")
            print("pressed in \(ms(t0)) ms")
        }
    case "press", "action":
        try requireFixture()
        let n = try locate(arg(0))
        let name = cmd == "press" ? "AXPress" : arg(1)
        let before = shown(n)
        let t0 = Date()
        try n.perform(name)
        let (after, waited) = waitChange(n, from: before)
        print("\(name): \(before ?? "-") → \(after ?? "-") (call \(ms(t0)) ms, change seen after \(waited) ms)")
    case "set", "setnum":
        try requireFixture()
        let n = try locate(arg(0))
        if cmd == "setnum" && Double(arg(1)) == nil { fail("not a number: \(arg(1))") }
        let value: AXScalar = cmd == "setnum" ? .number(Double(arg(1))!) : .string(arg(1))
        let before = shown(n)
        let t0 = Date()
        try n.set(kAXValueAttribute, value)
        if cmd == "set", (try n.attrs().actions).contains("AXConfirm") { try n.perform("AXConfirm") }
        let (after, waited) = waitChange(n, from: before)
        print("set \(value.stringValue): \(before ?? "-") → \(after ?? "-") (\(ms(t0)) ms, change after \(waited) ms)")
    case "setbool":
        try requireFixture()
        let n = try locate(arg(0))
        try n.setRaw(arg(1), bool: arg(2) == "true")
        print("\(arg(1)) := \(arg(2)); now \(try n.rawAttribute(arg(1)) ?? "<none>")")
    case "inc", "dec":
        try requireFixture()
        let n = try locate(arg(0))
        let count = args.count > 1 ? Int(arg(1)) ?? 1 : 1
        for i in 1...count {
            let before = shown(n)
            try n.perform(cmd == "inc" ? "AXIncrement" : "AXDecrement")
            let (after, waited) = waitChange(n, from: before)
            print("\(i): \(before ?? "-") → \(after ?? "-") (\(waited) ms)")
        }
    case "observe":
        let seconds = Double(option("--for") ?? "") ?? 10
        let names = option("--notifications")?.split(separator: ",").map(String.init)
        let target = try option("--at").map { try locate($0).element } ?? root.appNode.element
        try observe(pid: pid, target: target, names: names, seconds: seconds)
    case "mmc":
        try requireFixture()
        try sendMMC(Array(args))
    case "cc":
        try requireFixture()
        try sendCC(channel: UInt8(arg(0)) ?? 1, controller: UInt8(arg(1)) ?? 0, value: UInt8(arg(2)) ?? 0)
    default:
        fail(usage, code: 2)
    }
} catch {
    fail("error: \(error)")
}
