public enum TrackKind: String, Sendable { case audio, instrument, aux, stack, unknown }

public struct TrackInfo: Equatable, Sendable {
    public var number: Int
    public var name: String
    public var kind: TrackKind
    public var mute: Bool?
    public var solo: Bool?
    public var arm: Bool?
    public var selected: Bool
    public var hasOutput: Bool
    public var takeLanes: Int
    public var volume: String?
    public var pan: String?

    public init(number: Int, name: String, kind: TrackKind = .unknown, mute: Bool? = nil, solo: Bool? = nil,
                arm: Bool? = nil, selected: Bool = false, hasOutput: Bool = true, takeLanes: Int = 0,
                volume: String? = nil, pan: String? = nil) {
        self.number = number; self.name = name; self.kind = kind; self.mute = mute; self.solo = solo; self.arm = arm
        self.selected = selected; self.hasOutput = hasOutput; self.takeLanes = takeLanes; self.volume = volume; self.pan = pan
    }
}

public struct InsertInfo: Equatable, Sendable {
    public var slot: Int
    public var name: String
    public var bypassed: Bool?
    public init(slot: Int, name: String, bypassed: Bool?) { self.slot = slot; self.name = name; self.bypassed = bypassed }
}

public struct StripInfo: Equatable, Sendable {
    public var volume: String?
    public var pan: String?
    public var inserts: [InsertInfo]
    public var peak: String?
}

public enum TransportState: String, Sendable { case stopped, playing, recording, paused }

public struct TransportInfo: Equatable, Sendable {
    public var state: TransportState?
    public var position: String?
    public var cycle: Bool?
}

public struct ProjectInfo: Equatable, Sendable {
    public var name: String
    public var logicVersion: String?
}
