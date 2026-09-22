import CoreMIDI
import Foundation

/// Spikes S6/S11: a virtual source with the same name the server uses.
private func withSource(_ body: (MIDIEndpointRef) -> Void) throws {
    var client = MIDIClientRef()
    var status = MIDIClientCreate("logic-probe" as CFString, nil, nil, &client)
    guard status == noErr else { throw NSError(domain: "midi", code: Int(status)) }
    var source = MIDIEndpointRef()
    status = MIDISourceCreate(client, "LogicProMCP-Out" as CFString, &source)
    guard status == noErr else { throw NSError(domain: "midi", code: Int(status)) }
    Thread.sleep(forTimeInterval: 1.0)   // let Logic notice the new source
    body(source)
    Thread.sleep(forTimeInterval: 0.5)
    MIDIEndpointDispose(source)
    MIDIClientDispose(client)
}

private func send(_ bytes: [UInt8], via source: MIDIEndpointRef) {
    var list = MIDIPacketList()
    let packet = MIDIPacketListInit(&list)
    _ = MIDIPacketListAdd(&list, MemoryLayout<MIDIPacketList>.size, packet, 0, bytes.count, bytes)
    MIDIReceived(source, &list)
}

func sendMMC(_ args: [String]) throws {
    guard let command = args.first else { throw NSError(domain: "usage: mmc play|stop|locate HH:MM:SS:FF", code: 2) }
    let bytes: [UInt8]
    switch command {
    case "play": bytes = [0xF0, 0x7F, 0x7F, 0x06, 0x02, 0xF7]
    case "stop": bytes = [0xF0, 0x7F, 0x7F, 0x06, 0x01, 0xF7]
    case "locate":
        let parts = (args.dropFirst().first ?? "00:00:00:00").split(separator: ":").compactMap { UInt8($0) }
        guard parts.count == 4 else { throw NSError(domain: "locate expects HH:MM:SS:FF", code: 2) }
        bytes = [0xF0, 0x7F, 0x7F, 0x06, 0x44, 0x06, 0x01, parts[0], parts[1], parts[2], parts[3], 0x00, 0xF7]
    default: throw NSError(domain: "unknown mmc command \(command)", code: 2)
    }
    try withSource { send(bytes, via: $0) }
    print("sent MMC \(command): " + bytes.map { String(format: "%02X", $0) }.joined(separator: " "))
}

func sendCC(channel: UInt8, controller: UInt8, value: UInt8) throws {
    let status = 0xB0 | ((max(channel, 1) - 1) & 0x0F)
    try withSource { send([status, controller & 0x7F, value & 0x7F], via: $0) }
    print("sent CC ch\(channel) #\(controller) = \(value)")
}
