import AppKit
import ApplicationServices

public enum LogicApp {
    public static let bundleID = "com.apple.logic10"

    public static func running() -> NSRunningApplication? {
        NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).first
    }

    public static var pid: pid_t? { running()?.processIdentifier }

    public static func version() -> String? {
        guard let url = running()?.bundleURL, let bundle = Bundle(url: url) else { return nil }
        return bundle.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /// "11.2.1" → "11.2". The ledger is keyed by minor version (spec §5.6).
    public static func minor(_ version: String) -> String {
        version.split(separator: ".").prefix(2).joined(separator: ".")
    }

    public static var axTrusted: Bool { AXIsProcessTrusted() }
}

/// Live mutations only against project copies named `fixture-*` (spec §5.6).
public enum FixtureGuard {
    public static let prefix = "fixture-"

    public static func allows(mainWindowTitle: String?) -> Bool {
        mainWindowTitle?.hasPrefix(prefix) ?? false
    }
}
