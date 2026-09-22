#!/usr/bin/env python3
"""40-track SMF for the 'big' fixture.
Tracks T01-T20 play bars 1-4; T21-T40 play bars 180-183 (right of the screen at default zoom).
The conductor track has 20 markers (M1..M20), one every 8 bars."""
import struct
import sys

PPQ = 480
BAR = PPQ * 4


def vlq(n):
    out = [n & 0x7F]
    n >>= 7
    while n:
        out.insert(0, (n & 0x7F) | 0x80)
        n >>= 7
    return bytes(out)


def meta(kind, payload):
    return bytes([0xFF, kind]) + vlq(len(payload)) + payload


def track(events):
    events.sort(key=lambda e: e[0])
    data, last = b"", 0
    for tick, ev in events:
        data += vlq(tick - last) + ev
        last = tick
    data += vlq(0) + b"\xff\x2f\x00"
    return b"MTrk" + struct.pack(">I", len(data)) + data


conductor = [(0, meta(0x51, (500000).to_bytes(3, "big"))), (0, meta(0x58, bytes([4, 2, 24, 8])))]
conductor += [(m * 8 * BAR, meta(0x06, f"M{m + 1}".encode())) for m in range(20)]
tracks = [track(conductor)]
for i in range(40):
    ch, note = i % 16, 48 + (i % 24)
    first_bar = 0 if i < 20 else 179
    ev = [(0, meta(0x03, f"T{i + 1:02d}".encode()))]
    for b in range(first_bar, first_bar + 4):
        ev.append((b * BAR, bytes([0x90 | ch, note, 96])))
        ev.append((b * BAR + BAR - 1, bytes([0x80 | ch, note, 0])))
    tracks.append(track(ev))

out = sys.argv[1] if len(sys.argv) > 1 else "big.mid"
with open(out, "wb") as f:
    f.write(b"MThd" + struct.pack(">IHHH", 6, 1, len(tracks), PPQ) + b"".join(tracks))
print(out)
