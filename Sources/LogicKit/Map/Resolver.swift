public enum Resolver {
    public static func label(_ t: TrackInfo) -> String { "track:\(t.number) \"\(t.name)\"" }

    public static func trackFingerprints(_ tracks: [TrackInfo]) -> [Fingerprint] {
        tracks.indices.map { i in
            Fingerprint(kind: .track, number: tracks[i].number, name: tracks[i].name, parent: "/",
                        prev: i > 0 ? tracks[i - 1].name : nil, next: i + 1 < tracks.count ? tracks[i + 1].name : nil)
        }
    }

    public static func handles(for tracks: [TrackInfo], table: HandleTable) -> [String] {
        trackFingerprints(tracks).map(table.handle(for:))
    }

    public static func track(_ selector: Selector, in tracks: [TrackInfo], table: HandleTable) throws -> (TrackInfo, note: String?) {
        switch selector {
        case .number(let n):
            if let t = tracks.first(where: { $0.number == n }) { return (t, nil) }
            let near = tracks.sorted { abs($0.number - n) < abs($1.number - n) }.prefix(5).map(label)
            throw LogicError.notFound("track:\(n)", candidates: Array(near))
        case .name(let name):
            let hits = tracks.filter { $0.name == name }
            if hits.count == 1 { return (hits[0], nil) }
            if hits.count > 1 { throw LogicError.ambiguous("track:\"\(name)\"", candidates: hits.map(label)) }
            throw LogicError.notFound("track:\"\(name)\"", candidates: tracks.filter { $0.name.localizedCaseInsensitiveContains(name) }.map(label))
        case .selected:
            let sel = tracks.filter(\.selected)
            guard sel.count == 1 else { throw LogicError.unavailable(sel.isEmpty ? "no track is selected" : "\(sel.count) tracks are selected") }
            return (sel[0], nil)
        case .handle(let h):
            guard let fp = table.fingerprint(h) else { throw LogicError.staleRef(h) }
            switch HandleTable.match(fp, in: trackFingerprints(tracks)) {
            case .exact(let i): return (tracks[i], nil)
            case .moved(let i):
                guard tracks[i].name == fp.name else { throw LogicError.staleRef(h) }
                return (tracks[i], "moved \(fp.number.map(String.init) ?? "?")→\(tracks[i].number)")
            case .stale: throw LogicError.staleRef(h)
            }
        case .id(let s):
            throw LogicError.invalidArgs(signature: "track:<number>|\"<name>\"|selected|#handle", detail: "bad track selector \(s)")
        }
    }

    /// UI track numbers are global (spec §4.3): track:3/track:5 → track:5. Stack membership is checked from P2.
    public static func canonical(_ path: LPath) -> LPath {
        var segs = path.segments
        while segs.count >= 2, segs[0].kind == .track, segs[1].kind == .track { segs.removeFirst() }
        return LPath(segments: segs, property: path.property)
    }
}
