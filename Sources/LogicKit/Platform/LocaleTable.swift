public enum Anchor: String, CaseIterable, Sendable {
    case tracksHeader, trackRowDescPrefix, takeLaneSuffix, noOutputFlag
    case mute, solo, recordEnable, headerVolume, headerPan
    case inspectorStripHelpPrefix, stripVolume, stripPan, pluginBypass, pluginOpen, pluginList, peakMeterTitlePrefix
    case controlBar, play, stop, record, pause, cycle, positionField
    case menuEdit, menuUndoPrefix, menuRedoPrefix
    case modalSubroles
}

/// Every AX string Logic shows lives here (spec §9). Another UI language = another table.
public struct LocaleTable: Sendable {
    public let language: String
    private let strings: [Anchor: String]

    public subscript(_ a: Anchor) -> String { strings[a] ?? "" }
    public func list(_ a: Anchor) -> [String] { self[a].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }

    public static let en = LocaleTable(language: "en", strings: [
        .tracksHeader: "Tracks header", .trackRowDescPrefix: "Track ", .takeLaneSuffix: "Take", .noOutputFlag: "no output",
        .mute: "Mute", .solo: "Solo", .recordEnable: "Record Enable", .headerVolume: "Volume", .headerPan: "Pan",
        .inspectorStripHelpPrefix: "Left inspector channel strip", .stripVolume: "volume fader", .stripPan: "pan",
        .pluginBypass: "bypass", .pluginOpen: "open", .pluginList: "list", .peakMeterTitlePrefix: "peak level meter",
        .controlBar: "Control Bar", .play: "Play", .stop: "Stop", .record: "Record", .pause: "Pause", .cycle: "Cycle",
        .positionField: "Position",
        .menuEdit: "Edit", .menuUndoPrefix: "Undo", .menuRedoPrefix: "Redo",
        .modalSubroles: "AXDialog, AXSystemDialog",
    ])
}
