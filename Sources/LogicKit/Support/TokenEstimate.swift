/// Conservative token estimate used by budget tests (spec §7): ASCII ≈ 4 chars/token, non-ASCII scalar = 1 token.
public enum TokenEstimate {
    public static func count(_ s: String) -> Int {
        var ascii = 0, other = 0
        for u in s.unicodeScalars { if u.isASCII { ascii += 1 } else { other += 1 } }
        return (ascii + 3) / 4 + other
    }
}
