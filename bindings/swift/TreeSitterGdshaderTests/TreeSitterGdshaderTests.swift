import XCTest
import SwiftTreeSitter
import TreeSitterGdshader

final class TreeSitterGdshaderTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_gdshader())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Gdshader grammar")
    }
}
