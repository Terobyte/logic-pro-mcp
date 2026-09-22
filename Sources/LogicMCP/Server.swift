import LogicKit
import MCP

enum Handlers {
    static func call(_ p: CallTool.Parameters, session: LogicSession) async -> CallTool.Result {
        do {
            let text: String
            switch p.name {
            case "logic_read":
                let a = try ArgValidator.read(p.arguments)
                text = try await session.read(a.path, depth: a.depth, fields: a.fields, page: a.page)
            case "logic_set":
                text = try await session.set(try ArgValidator.set(p.arguments))
            case "logic_do":
                text = try await session.perform(steps: try ArgValidator.perform(p.arguments))
            case "logic_midi":
                text = try await session.midi(try ArgValidator.midi(p.arguments))
            default:
                throw LogicError.invalidArgs(signature: "tools: logic_read, logic_set, logic_do, logic_midi", detail: "unknown tool \(p.name)")
            }
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch let e as LogicError {
            return CallTool.Result(content: [.text(e.text)], isError: true)
        } catch {
            return CallTool.Result(content: [.text("unavailable: \(error)")], isError: true)
        }
    }
}

actor MCPServer {
    let session: LogicSession
    init(session: LogicSession) { self.session = session }

    func start() async throws {
        let server = Server(name: "logic-pro-mcp", version: LogicKitInfo.version,
                            capabilities: .init(tools: .init(listChanged: false)))
        let caps = Grammar.advertised(ledger: .bundled(), logicMinor: LogicApp.version().map(LogicApp.minor))
        let tools = ToolDefs.all(advertised: caps)
        let session = self.session
        await server.withMethodHandler(ListTools.self) { _ in ListTools.Result(tools: tools) }
        await server.withMethodHandler(CallTool.self) { params in await Handlers.call(params, session: session) }
        Log.info("logic-pro-mcp \(LogicKitInfo.version): \(caps.count) live-verified capabilities", subsystem: "server")
        try await server.start(transport: StdioTransport())
        await server.waitUntilCompleted()
    }
}
