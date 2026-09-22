import Foundation

/// "Edit>^Undo": menu-bar title, then item titles; a leading "^" matches a title prefix.
public enum MenuPath {
    public static func split(_ s: String) -> [String] {
        s.split(separator: ">").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    public static func resolve(menuBar: any AXNode, path: [String]) throws -> (any AXNode)? {
        var current: any AXNode = menuBar
        for (i, component) in path.enumerated() {
            let op: AXMatch.Op = component.hasPrefix("^") ? .prefix(String(component.dropFirst())) : .equals(component)
            let items: [any AXNode]
            if i == 0 {
                items = try current.children()
            } else {
                guard let menu = try current.firstChild(AXMatch(role: "AXMenu")) else { return nil }
                items = try menu.children()
            }
            guard let next = try items.first(where: { op.test(try $0.attrs().title) }) else { return nil }
            current = next
        }
        return current
    }
}
