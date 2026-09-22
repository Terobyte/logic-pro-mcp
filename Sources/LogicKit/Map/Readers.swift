import Foundation

func boolValue(_ v: AXScalar?) -> Bool? {
    switch v {
    case .bool(let b)?: return b
    case .number(let d)?: return d != 0
    case .string(let s)?: return s == "1"
    case nil: return nil
    }
}

/// `Track 3 “Warm Vocal”, Take` → number 3, name, flags ["Take"].
public struct TrackRowDesc: Equatable, Sendable {
    public var number: Int
    public var name: String
    public var flags: [String]

    public static func parse(_ desc: String, locale: LocaleTable) -> TrackRowDesc? {
        guard desc.hasPrefix(locale[.trackRowDescPrefix]) else { return nil }
        let rest = desc.dropFirst(locale[.trackRowDescPrefix].count)
        guard let number = Int(rest.prefix(while: \.isNumber)),
              let open = rest.firstIndex(of: "“"), let close = rest.lastIndex(of: "”"), open < close else { return nil }
        let name = String(rest[rest.index(after: open)..<close])
        let flags = rest[rest.index(after: close)...].split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        return TrackRowDesc(number: number, name: name, flags: flags)
    }
}

public enum TrackReader {
    public static func header(_ root: any AXRoot, _ L: LocaleTable) throws -> any AXNode {
        guard let main = try root.mainWindow() else { throw LogicError.unavailable("Logic has no main window") }
        guard let h = try main.firstDescendant(AXMatch(role: "AXGroup", desc: .equals(L[.tracksHeader]))) else {
            throw LogicError.anchorMissing("tracksHeader")
        }
        return h
    }

    public static func read(_ root: any AXRoot, _ L: LocaleTable) throws -> [TrackInfo] {
        var result: [TrackInfo] = []
        for row in try header(root, L).children() {
            let a = try row.attrs()
            guard let d = a.desc, let p = TrackRowDesc.parse(d, locale: L) else { continue }
            if p.flags.contains(L[.takeLaneSuffix]) {
                if let i = result.lastIndex(where: { $0.number == p.number }) { result[i].takeLanes += 1 }
                continue
            }
            func toggle(_ anchor: Anchor) throws -> Bool? {
                boolValue(try row.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[anchor])), maxDepth: 4)?.attrs().value)
            }
            func slider(_ anchor: Anchor) throws -> String? {
                try row.firstDescendant(AXMatch(role: "AXSlider", desc: .equals(L[anchor])), maxDepth: 4)?.attrs().valueDescription
            }
            let triangle = try row.firstDescendant(AXMatch(role: "AXDisclosureTriangle"), maxDepth: 3) != nil
            result.append(TrackInfo(number: p.number, name: p.name, kind: triangle ? .stack : .unknown,
                                    mute: try toggle(.mute), solo: try toggle(.solo), arm: try toggle(.recordEnable),
                                    selected: a.selected ?? false, hasOutput: !p.flags.contains(L[.noOutputFlag]),
                                    volume: try slider(.headerVolume), pan: try slider(.headerPan)))
        }
        // A take folder also has a disclosure triangle: it is not a stack.
        for i in result.indices where result[i].takeLanes > 0 && result[i].kind == .stack { result[i].kind = .unknown }
        return result
    }

    public static func row(number: Int, _ root: any AXRoot, _ L: LocaleTable) throws -> any AXNode {
        for row in try header(root, L).children() {
            guard let d = try row.attrs().desc, let p = TrackRowDesc.parse(d, locale: L),
                  p.number == number, !p.flags.contains(L[.takeLaneSuffix]) else { continue }
            return row
        }
        throw LogicError.notFound("track:\(number)", candidates: [])
    }

    public static func selectedNumber(_ root: any AXRoot, _ L: LocaleTable) throws -> Int? {
        for row in try header(root, L).children() {
            let a = try row.attrs()
            guard a.selected == true, let d = a.desc, let p = TrackRowDesc.parse(d, locale: L),
                  !p.flags.contains(L[.takeLaneSuffix]) else { continue }
            return p.number
        }
        return nil
    }
}

public enum StripReader {
    /// Spec §4.2: the full strip exists only for the selected track (Left inspector channel strip).
    /// Slot numbers follow plugin order; gaps between slots are checked from P2 (S7).
    public static func inspector(_ root: any AXRoot, _ L: LocaleTable) throws -> StripInfo? {
        guard let main = try root.mainWindow(),
              let strip = try main.firstDescendant(AXMatch(role: "AXLayoutItem", help: .prefix(L[.inspectorStripHelpPrefix]))) else { return nil }
        let volume = try strip.firstDescendant(AXMatch(role: "AXSlider", desc: .equals(L[.stripVolume])))?.attrs().valueDescription
        let pan = try strip.firstDescendant(AXMatch(role: "AXSlider", desc: .equals(L[.stripPan])))?.attrs().valueDescription
        var inserts: [InsertInfo] = []
        for group in try strip.allDescendants(AXMatch(role: "AXGroup"), descendIntoMatches: true) {
            guard let bypass = try group.firstChild(AXMatch(role: "AXCheckBox", desc: .equals(L[.pluginBypass]))),
                  let name = try group.attrs().desc, !name.isEmpty else { continue }
            inserts.append(InsertInfo(slot: inserts.count + 1, name: name, bypassed: boolValue(try bypass.attrs().value)))
        }
        let peakTitle = try strip.firstDescendant(AXMatch(title: .prefix(L[.peakMeterTitlePrefix])))?.attrs().title
        let peak = peakTitle.flatMap { t in t.range(of: ", ").map { String(t[$0.upperBound...]) } }
        return StripInfo(volume: volume, pan: pan, inserts: inserts, peak: peak)
    }
}

public enum TransportReader {
    public static func controlBar(_ root: any AXRoot, _ L: LocaleTable) throws -> any AXNode {
        guard let main = try root.mainWindow() else { throw LogicError.unavailable("Logic has no main window") }
        guard let bar = try main.firstDescendant(AXMatch(role: "AXGroup", desc: .equals(L[.controlBar]))) else {
            throw LogicError.anchorMissing("controlBar")
        }
        return bar
    }

    public static func read(_ root: any AXRoot, _ L: LocaleTable) throws -> TransportInfo {
        let bar = try controlBar(root, L)
        func on(_ a: Anchor) throws -> Bool? {
            boolValue(try bar.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[a])), maxDepth: 5)?.attrs().value)
        }
        let rec = try on(.record), play = try on(.play), pause = try on(.pause)
        let state: TransportState? = rec == true ? .recording : pause == true ? .paused : play == true ? .playing
            : play == nil ? nil : .stopped
        let pos = try bar.firstDescendant(AXMatch(desc: .equals(L[.positionField])), maxDepth: 6)?.attrs()
        return TransportInfo(state: state, position: pos?.valueDescription ?? pos?.value?.stringValue, cycle: try on(.cycle))
    }
}

public enum ModalGuard {
    /// Spec §5.4: a modal becomes AXMainWindow; its subrole tells it apart (rule from S1).
    public static func modalTitle(_ root: any AXRoot, _ L: LocaleTable) throws -> String? {
        guard let a = try root.mainWindow()?.attrs(), let sub = a.subrole else { return nil }
        return L.list(.modalSubroles).contains(sub) ? (a.title ?? "untitled") : nil
    }
}

public enum ProjectReader {
    public static func read(_ root: any AXRoot, version: String?) throws -> ProjectInfo {
        let title = try root.mainWindow()?.attrs().title ?? ""
        return ProjectInfo(name: title.components(separatedBy: " - ").first ?? title, logicVersion: version)
    }
}

public enum AnchorProbe {
    /// Version fingerprint (spec §9): anchors the P1 slice cannot work without.
    public static func missing(_ root: any AXRoot, _ L: LocaleTable) throws -> [Anchor] {
        var out: [Anchor] = []
        do { _ = try TrackReader.header(root, L) } catch LogicError.anchorMissing { out.append(.tracksHeader) }
        do { _ = try TransportReader.controlBar(root, L) } catch LogicError.anchorMissing { out.append(.controlBar) }
        return out
    }
}
