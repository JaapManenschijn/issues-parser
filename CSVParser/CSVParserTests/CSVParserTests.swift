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
    
    func testParseProperCsv() throws {
        let data = properCsv.data(using: .utf8)
        let expect = expectation(description: "result")
        
        CSVParserPublisher(data: data!)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { users in
                XCTAssertEqual(3, users.count)
                for user in users {
                    XCTAssertNotNil(user.firstName)
                    XCTAssertNotNil(user.surName)
                    XCTAssertNotEqual(0, user.issueCount)
                    XCTAssertNotNil(user.dateOfBirth)
                }
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expect], timeout: 30)
    }
    
    func testParseProperCsvWithCommas() throws {
        let data = properCsvWithCommas.data(using: .utf8)
        let expect = expectation(description: "result")
        
        CSVParserPublisher(data: data!)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { users in
                XCTAssertEqual(3, users.count)
                XCTAssertEqual("Jan,sen", users[0].surName)
                XCTAssertEqual("Fi,ona", users[1].firstName)
                XCTAssertEqual("de, Vries", users[1].surName)
                XCTAssertEqual("Pe,tra", users[2].firstName)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expect], timeout: 30)
    }
    
    func testMalformedCsv() throws {
        let data = malformedCsvWrongColumns.data(using: .utf8)
        let expect = expectation(description: "result")
        
        CSVParserPublisher(data: data!)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssert(error is MalformedCSVError)
                    expect.fulfill()
                default:
                    break
                }
            } receiveValue: { users in
                XCTAssertEqual(0, users.count)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expect], timeout: 30)
    }
    
    func testWrongDelimiter() throws {
        let data = malformedCsvWrongDelimiter.data(using: .utf8)
        let expect = expectation(description: "result")
        
        CSVParserPublisher(data: data!)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    XCTAssertNotNil(error)
                    expect.fulfill()
                default:
                    break
                }
            } receiveValue: { users in
                XCTAssertEqual(0, users.count)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expect], timeout: 30)
    }
    
    func testBigCsv() throws {
        let testBundle = Bundle(for: type(of: self))
        if let url = testBundle.url(forResource: "bigCsv", withExtension: "csv") {
            let data = try Data(contentsOf: url)
            let expect = expectation(description: "result")
            
            CSVParserPublisher(data: data)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        XCTAssertNotNil(error)
                        expect.fulfill()
                    default:
                        break
                    }
                } receiveValue: { users in
                    XCTAssertEqual(200000, users.count)
                    expect.fulfill()
                }
                .store(in: &cancellables)
            
            wait(for: [expect], timeout: 180)
        }
    }
    
}
