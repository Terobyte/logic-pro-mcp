import LogicKit
import MCP

enum ToolDefs {
    static func prop(_ type: String, _ desc: String) -> Value { .object(["type": .string(type), "description": .string(desc)]) }

    static func all(advertised caps: [Capability]) -> [Tool] {
        let actions = Array(Set(caps.compactMap { c -> String? in if case .action = c.form { return c.name }; return nil })).sorted()
        return [
            Tool(name: "logic_read",
                 description: "Read Logic Pro as a map, in Logic units. Paths: / · track:3|track:\"Name\"|track:selected|#handle [/strip|/raw] · transport · system · system/schema/<kind>. Long lists fold; use page or fields. Live: \(Grammar.index(caps))",
                 inputSchema: .object(["type": .string("object"), "additionalProperties": .bool(false), "properties": .object([
                    "path": prop("string", "default /"), "depth": prop("integer", "0..3"),
                    "fields": prop("string", "name,kind,mute,solo,arm,selected,volume,pan,takes"), "page": prop("string", "e.g. 13-24"),
                 ])]),
                 annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: false)),
            Tool(name: "logic_set",
                 description: "Set properties in order, each verified by readback. Stops at the first error (partial). Example: {assign:[{path:\"track:2/mute\",value:\"on\"}]}",
                 inputSchema: .object(["type": .string("object"), "required": .array([.string("assign")]), "properties": .object([
                    "assign": .object(["type": .string("array"), "items": .object(["type": .string("object"), "required": .array([.string("path"), .string("value")]),
                        "properties": .object(["path": prop("string", "node/property"), "value": prop("string", "Logic units, e.g. on, -6 dB, 17 1 1 1")])])]),
                 ])]),
                 annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: true, openWorldHint: false)),
            Tool(name: "logic_do",
                 description: "Run a verified action on a node, or ordered steps. Details: logic_read system/schema/<kind>.",
                 inputSchema: .object(["type": .string("object"), "properties": .object([
                    "path": prop("string", "node, e.g. track:3, /, transport"),
                    "action": .object(["type": .string("string"), "enum": .array(actions.map { .string($0) })]),
                    "args": prop("object", "action arguments"),
                    "steps": prop("array", "[{path, action, args?}]"),
                 ])]),
                 annotations: .init(readOnlyHint: false, destructiveHint: true, idempotentHint: false, openWorldHint: false)),
            Tool(name: "logic_midi",
                 description: "Send realtime MIDI from the LogicProMCP-Out source. Result is 'sent' (not verified).",
                 inputSchema: .object(["type": .string("object"), "required": .array([.string("events")]), "properties": .object([
                    "events": prop("array", "[{type: note|cc|pc|pitchbend, ch?, note, vel?, dur_ms?, cc, value, program}]"),
                 ])]),
                 annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false, openWorldHint: false)),
        ]
    }
}
