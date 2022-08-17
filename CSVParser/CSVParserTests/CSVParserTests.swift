//
//  CSVParserTests.swift
//  CSVParserTests
//
//  Created by J Manenschijn on 16/08/2022.
//

import XCTest
@testable import CSVParser
import Combine

class CSVParserTests: XCTestCase {
    let properCsv = """
    "First name","Sur name","Issue count","Date of birth"
    "Theo","Jansen",5,"1978-01-02T00:00:00"
    "Fiona","de Vries",7,"1950-11-12T00:00:00"
    "Petra","Boersma",1,"2001-04-20T00:00:00"
    """
    
    let properCsvWithCommas = """
    "First name","Sur name","Issue count","Date of birth"
    "Theo","Jan,sen",5,"1978-01-02T00:00:00"
    "Fi,ona","de, Vries",7,"1950-11-12T00:00:00"
    "Pe,tra","Boersma",1,"2001-04-20T00:00:00"
    """
    
    let malformedCsvWrongColumns = """
    "firstname","lastname","issues","dob"
    "Theo","Jansen",5,"1978-01-02T00:00:00"
    "Fiona","de Vries",7,"1950-11-12T00:00:00"
    "Petra","Boersma",1,"2001-04-20T00:00:00"
    """
    
    let malformedCsvWrongDelimiter = """
    "First name";"Sur name";"Issue count";"Date of birth"
    "Theo";"Jansen";5;"1978-01-02T00:00:00"
    "Fiona";"de Vries";7;"1950-11-12T00:00:00"
    "Petra";"Boersma";1;"2001-04-20T00:00:00"
    """
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    func testParseProperCsv() async throws {
        let data = properCsv.data(using: .utf8)!
        
        let parser = CSVParser(data: data)
        var users: [User] = []
        
        for await user in try parser.parse() {
            users.append(user)
        }
        
        XCTAssertEqual(3, users.count)
        for user in users {
            XCTAssertNotNil(user.firstName)
            XCTAssertNotNil(user.surName)
            XCTAssertNotEqual(0, user.issueCount)
            XCTAssertNotNil(user.dateOfBirth)
        }
    }
    
    func testParseProperCsvWithCommas() async throws {
        let data = properCsvWithCommas.data(using: .utf8)!
        
        let parser = CSVParser(data: data)
        var users: [User] = []
        
        for await user in try parser.parse() {
            users.append(user)
        }
        
        XCTAssertEqual(3, users.count)
        XCTAssertEqual("Jan,sen", users[0].surName)
        XCTAssertEqual("Fi,ona", users[1].firstName)
        XCTAssertEqual("de, Vries", users[1].surName)
        XCTAssertEqual("Pe,tra", users[2].firstName)
    }
    
    func testMalformedCsv() async throws {
        let data = malformedCsvWrongColumns.data(using: .utf8)!
        
        let parser = CSVParser(data: data)
        var users: [User] = []
        
        do {
            for await user in try parser.parse() {
                users.append(user)
            }
        } catch let error {
            XCTAssert(error is MalformedCSVError)
        }
        XCTAssertEqual(0, users.count)
    }
    
    func testWrongDelimiter() async throws {
        let data = malformedCsvWrongDelimiter.data(using: .utf8)!
        
        let parser = CSVParser(data: data)
        var users: [User] = []
        
        do {
            for await user in try parser.parse() {
                users.append(user)
            }
        } catch let error {
            XCTAssertNotNil(error)
        }
    }
    
    func testBigCsv() async throws {
        let testBundle = Bundle(for: type(of: self))
        if let url = testBundle.url(forResource: "bigCsv", withExtension: "csv") {
            let data = try Data(contentsOf: url)
            
            let parser = CSVParser(data: data)
            var users: [User] = []
            
            for await user in try parser.parse() {
                users.append(user)
            }
            
            XCTAssertEqual(200000, users.count)
        }
    }
    
}
