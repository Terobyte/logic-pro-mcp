import ApplicationServices
import Foundation
import LogicKit

/// Spike S2: which AX notifications Logic actually sends.
func observe(pid: pid_t, target: AXUIElement, names: [String]?, seconds: Double) throws {
    let wanted = names ?? [
        kAXValueChangedNotification, kAXFocusedUIElementChangedNotification, kAXFocusedWindowChangedNotification,
        kAXMainWindowChangedNotification, kAXWindowCreatedNotification, kAXUIElementDestroyedNotification,
        kAXTitleChangedNotification, kAXSelectedChildrenChangedNotification, kAXSelectedRowsChangedNotification,
        kAXLayoutChangedNotification, kAXCreatedNotification,
    ]
    var observer: AXObserver?
    let status = AXObserverCreate(pid, { _, element, name, _ in
        let line = (try? LiveAXNode(element).attrs())?.compactLine ?? "?"
        print(String(format: "%.3f ", Date().timeIntervalSince1970) + (name as String) + " " + line)
        fflush(stdout)
    }, &observer)
    guard status == .success, let observer else { throw AXCallError.failure(status.rawValue) }
    for n in wanted {
        let r = AXObserverAddNotification(observer, target, n as CFString, nil)
        print("subscribe \(n): \(r == .success ? "ok" : "AXError \(r.rawValue)")")
    }
    CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observer), .defaultMode)
    print("observing for \(Int(seconds)) s…")
    fflush(stdout)
    CFRunLoopRunInMode(.defaultMode, seconds, false)
}
