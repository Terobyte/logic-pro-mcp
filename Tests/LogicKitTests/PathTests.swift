import XCTest
@testable import LogicKit

final class PathTests: XCTestCase {
    func testRootForms() throws {
        XCTAssertEqual(try LPath.parse("/"), LPath(segments: []))
        XCTAssertEqual(try LPath.parse(""), LPath(segments: []))
        XCTAssertEqual(try LPath.parse("/track:3"), try LPath.parse("track:3"))
    }

    func testSelectors() throws {
        XCTAssertEqual(try LPath.parse("track:3").segments, [PathSegment(.track, .number(3))])
        XCTAssertEqual(try LPath.parse(#"track:"Rose \"V\"""#).segments, [PathSegment(.track, .name("Rose \"V\""))])
        XCTAssertEqual(try LPath.parse("track:selected/strip").segments, [PathSegment(.track, .selected), PathSegment(.strip)])
        XCTAssertEqual(try LPath.parse("#t4f2").segments, [PathSegment(.track, .handle("#t4f2"))])
        XCTAssertEqual(try LPath.parse("track:3/insert:2/param:Make Up").segments.last, PathSegment(.param, .name("Make Up")))
        XCTAssertEqual(try LPath.parse("render:r3").segments, [PathSegment(.render, .id("r3"))])
        XCTAssertEqual(try LPath.parse(#"track:3/region@"17 1 1 1""#).segments.last, PathSegment(.region, position: "17 1 1 1"))
    }

    func testPropertyAndSchema() throws {
        let p = try LPath.parse("track:3/mute")
        XCTAssertEqual(p.segments, [PathSegment(.track, .number(3))])
        XCTAssertEqual(p.property, "mute")
        XCTAssertEqual(try LPath.parse("system/schema/track").segments, [PathSegment(.system), PathSegment(.schema, .id("track"))])
    }

    func testErrors() {
        for bad in ["track", "transport:1", "bogus:1", #"track:"open"#, "track:3/mute/solo", "region"] {
            XCTAssertThrowsError(try LPath.parse(bad), bad) { e in
                guard case LogicError.invalidArgs = e else { return XCTFail("\(bad): \(e)") }
            }
        }
    }

    func testCanonicalDescription() throws {
        for s in ["/", "track:3", #"track:"Rose Vocal"/strip"#, "track:selected/insert:2/param:\"Make Up\"", "transport/position",
                  "system/schema/track", #"track:3/region@"17 1 1 1""#] {
            XCTAssertEqual(try LPath.parse(s).description, s)
        }
    }
}
