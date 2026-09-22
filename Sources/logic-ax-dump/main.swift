import Foundation
import LogicKit

func err(_ s: String) { FileHandle.standardError.write(Data((s + "\n").utf8)) }

let usage = "usage: logic-ax-dump --out file.json [--depth 40] [--roots mainWindow,menuBar,focusedWindow] [--project name] [--note text] [--timeout 2]"

var out: String?
var depth = 40
var roots = ["mainWindow", "menuBar"]
var project = ""
var note: String?
var timeout: Float = 2.0

var args = Array(CommandLine.arguments.dropFirst())
while !args.isEmpty {
    let flag = args.removeFirst()
    guard let value = args.first else { err(usage); exit(2) }
    args.removeFirst()
    switch flag {
    case "--out": out = value
    case "--depth": depth = Int(value) ?? depth
    case "--roots": roots = value.split(separator: ",").map(String.init)
    case "--project": project = value
    case "--note": note = value
    case "--timeout": timeout = Float(value) ?? timeout
    default: err(usage); exit(2)
    }
}

guard let out else { err(usage); exit(2) }
guard LogicApp.axTrusted else { err("Accessibility is not granted to this terminal"); exit(1) }
guard let pid = LogicApp.pid else { err("Logic Pro is not running"); exit(1) }

let root = LiveAXRoot(pid: pid, timeout: timeout)
var captured: [String: AXSnapshotNode] = [:]
do {
    for name in roots {
        let node: (any AXNode)?
        switch name {
        case "mainWindow": node = try root.mainWindow()
        case "menuBar": node = try root.menuBar()
        case "focusedWindow": node = try root.focusedWindow()
        default: err("unknown root \(name)"); exit(2)
        }
        guard let node else { err("\(name): none"); continue }
        AXStats.shared.reset()
        var stats = CaptureStats()
        let t0 = Date()
        captured[name] = try AXCapture.capture(node, depth: depth, stats: &stats)
        let ms = Int(Date().timeIntervalSince(t0) * 1000)
        err("\(name): nodes=\(stats.nodes) truncated=\(stats.truncatedAt) skipped=\(stats.skipped) ax_messages=\(AXStats.shared.messages) timeouts=\(AXStats.shared.timeouts) ms=\(ms)")
    }
    let fixture = AXFixture(
        meta: .init(logicVersion: LogicApp.version() ?? "unknown",
                    capturedAt: ISO8601DateFormatter().string(from: Date()),
                    project: project, note: note),
        roots: captured)
    try fixture.write(to: URL(fileURLWithPath: out))
    err("wrote \(out)")
} catch {
    err("dump failed: \(error)")
    exit(1)
}
