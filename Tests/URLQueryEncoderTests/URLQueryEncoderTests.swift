// The MIT License (MIT)
//
// Copyright (c) 2021 Alexander Grebenyuk (github.com/kean).

import XCTest
import URLQueryEncoder

final class QueryEncoderTests: XCTestCase {
    // MARK: Style: Form, Explode: True
    
    func testStyleFormExplodeTruePrimitive() throws {
        // GIVEN
        let id = 5
        
        // THEN
        let encoder = URLQueryEncoder()
        encoder.encode(["id": id])

        // THEN
        XCTAssertEqual(encoder.query, "id=5")
    }

    func testStyleFormExplodeTrueArray() throws {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.encode(["id": ids])
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3&id=4&id=5")
    }
    
    func testStyleFormExplodeTrueObject() throws {
        // GIVEN
        let user = User(role: "admin", name: "kean")
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.encode(["id": user])

        // THEN
        XCTAssertEqual(encoder.query, "role=admin&name=kean")
    }
    
    func testStyleFormExplodeTrueObjectPassedDirectly() throws {
        // GIVEN
        let user = User(role: "admin", name: "kean")
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.encode(user)

        // THEN
        XCTAssertEqual(encoder.query, "role=admin&name=kean")
    }
    
    // MARK: Style: Form, Explode: False
    
    func testStyleFormExplodeFalsePrimitive() throws {
        // GIVEN
        let id = 5
        
        // THEN
        let encoder = URLQueryEncoder()
        encoder.encode(["id": id])

        // THEN
        XCTAssertEqual(encoder.query, "id=5")
    }

    func testStyleFormExplodeFalseArray() throws {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.explode = false
        encoder.encode(["id": ids])
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3,4,5")
    }
    
    func testStyleFormExplodeFalseArrayPassInEncode() throws {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.encode(["id": ids], explode: false)
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3,4,5")
    }
    
    func testStyleFormExplodeFalseObject() {
        // GIVEN
        let user = User(role: "admin", name: "kean")
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.encode(["id": user], explode: false)
        
        // THEN
        XCTAssertEqual(encoder.query, "id=role,admin,name,kean")
    }
    
    // MARK: Style: SpaceDelimited
    
    // The rest of the combinations are invalid (the tool need to validate for that)

    // The same as "form"
    func testStyleSpaceDelimitedExplodeTrue() {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.explode = true
        encoder.delimeter = " "
        encoder.encode(["id": ids])
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3&id=4&id=5")
    }
    
    func testStyleSpaceDelimitedExplodeFalse() {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.explode = false
        encoder.delimeter = " "
        encoder.encode(["id": ids])
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3 4 5")
        XCTAssertEqual(encoder.percentEncodedQuery, "id=3%204%205")
    }
    
    func testStyleSpaceDelimitedExplodeFalsePassDelimeterDirectly() {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.encode(["id": ids], explode: false, delimeter: " ")
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3 4 5")
        XCTAssertEqual(encoder.percentEncodedQuery, "id=3%204%205")
    }
    
    // MARK: Style: PipeDelimited
    
    // The rest of the combinations are invalid (the tool need to validate for that)

    // The same as "form"
    func testStylePipeDelimitedExplodeTrue() {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.explode = true
        encoder.delimeter = "|"
        encoder.encode(["id": ids])
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3&id=4&id=5")
    }
    
    func testStylePipeDelimitedExplodeFalse() {
        // GIVEN
        let ids = [3, 4, 5]
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.explode = false
        encoder.delimeter = "|"
        encoder.encode(["id": ids])
        
        // THEN
        XCTAssertEqual(encoder.query, "id=3|4|5")
        XCTAssertEqual(encoder.percentEncodedQuery, "id=3%7C4%7C5")
    }
    
    // MARK: Style: DeepObject
    
    func testStyleDeepObject() {
        // GIVEN
        let user = User(role: "admin", name: "kean")
        
        // WHEN
        let encoder = URLQueryEncoder()
        encoder.explode = true
        encoder.isDeepObject = true
        encoder.encode(["id": user])
        
        // THEN
        XCTAssertEqual(encoder.query, "id[role]=admin&id[name]=kean")
        XCTAssertEqual(encoder.percentEncodedQuery, "id%5Brole%5D=admin&id%5Bname%5D=kean")
    }
}

private struct User: Encodable {
    var role: String
    var name: String
}
