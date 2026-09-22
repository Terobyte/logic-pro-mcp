import XCTest
@testable import LogicKit

struct FakeRecipe: Recipe {
    var spec: RecipeSpec
    var body: @Sendable (RecipeContext) throws -> Outcome
    func run(_ ctx: RecipeContext) throws -> Outcome { try body(ctx) }
}

final class FakeRestorer: TrackSelecting, @unchecked Sendable {
    var calls: [Int] = []
    func select(_ number: Int, ctx: RecipeContext) throws { calls.append(number) }
}

final class RecipeRunnerTests: XCTestCase {
    func env(_ edit: (inout AXFixture) -> Void = { _ in }) throws -> RecipeEnv {
        var fx = try AXFixture.load(Fixtures.url("ax/mini.json"))
        edit(&fx)
        return RecipeEnv(root: FixtureAXRoot(fx), locale: .en)
    }
    let okBody: @Sendable (RecipeContext) throws -> Outcome = { _ in .ok(path: "x", actual: "y") }

    func testSuccess() throws {
        XCTAssertEqual(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "t"), body: okBody), env: env()), .ok(path: "x", actual: "y"))
    }

    func testModalBlocks() throws {
        let e = try env { $0.roots["mainWindow"]!.a.subrole = "AXDialog"; $0.roots["mainWindow"]!.a.title = "Save Patch as…" }
        XCTAssertThrowsError(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "t"), body: okBody), env: e)) {
            XCTAssertEqual($0 as? LogicError, .blocked(.modal("Save Patch as…")))
        }
    }

    func testRecordingBlocksUnlessAllowed() throws {
        let e = try env { $0.roots["mainWindow"]!.c[1].c[1].a.value = .number(1) }   // Control Bar › Record = 1
        XCTAssertThrowsError(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "t"), body: okBody), env: e)) {
            XCTAssertEqual($0 as? LogicError, .blocked(.recording))
        }
        XCTAssertNoThrow(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "stop", allowWhileRecording: true), body: okBody), env: e))
    }

    func testCheckpointDetectsSelectionChange() throws {
        let r = FakeRecipe(spec: RecipeSpec(name: "t")) { ctx in ctx.expectedSelection = 3; try ctx.checkpoint(); return .ok(path: "x", actual: "y") }
        XCTAssertThrowsError(try RecipeRunner.run(r, env: env())) {
            XCTAssertEqual($0 as? LogicError, .blocked(.contextChanged("selection 3→2")))
        }
    }

    func testVanishedElementMapsToContextChanged() throws {
        let r = FakeRecipe(spec: RecipeSpec(name: "t")) { _ in throw AXCallError.invalidElement }
        XCTAssertThrowsError(try RecipeRunner.run(r, env: env())) {
            XCTAssertEqual($0 as? LogicError, .blocked(.contextChanged("UI element vanished during the operation")))
        }
    }

    func testSelectionRestoredOnSuccessAndFailure() throws {
        let restorer = FakeRestorer()
        let spec = RecipeSpec(name: "t", visibility: .restores, changesSelection: true)
        _ = try RecipeRunner.run(FakeRecipe(spec: spec, body: okBody), env: env(), restorer: restorer)
        _ = try? RecipeRunner.run(FakeRecipe(spec: spec) { _ in throw LogicError.unavailable("x") }, env: env(), restorer: restorer)
        XCTAssertEqual(restorer.calls, [2, 2])
    }
}
