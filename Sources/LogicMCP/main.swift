import Foundation
import LogicKit

if CommandLine.arguments.contains("--check-permissions") {
    let ok = LogicApp.axTrusted
    FileHandle.standardError.write(Data("Accessibility: \(ok ? "granted" : "NOT GRANTED — System Settings › Privacy & Security › Accessibility")\n".utf8))
    exit(ok ? 0 : 1)
}

do {
    try await MCPServer(session: .live()).start()
} catch {
    Log.error("server failed: \(error)", subsystem: "main")
    exit(1)
}
