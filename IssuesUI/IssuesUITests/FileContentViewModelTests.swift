//
//  FileContentViewModelTests.swift
//  IssuesUITests
//
//  Created by J Manenschijn on 19/08/2022.
//

import XCTest

@MainActor
class FileContentViewModelTests: XCTestCase {
    let properCsv = """
    "First name","Sur name","Issue count","Date of birth"
    "Theo","Jansen",5,"1978-01-02T00:00:00"
    "Fiona","de Vries",7,"1950-11-12T00:00:00"
    "Petra","Boersma",1,"2001-04-20T00:00:00"
    """

    func testShowingAlertWhenDataNil() async throws {
        let viewModel = FileContentViewModel(data: nil, fileName: nil)
        await viewModel.loadData()
        XCTAssertTrue(viewModel.showingAlert)
    }
    
    func testFileNameNilWhenPassingNil() throws {
        let viewModel = FileContentViewModel(data: nil, fileName: nil)
        XCTAssertNil(viewModel.fileName)
    }
    
    func testFileNameMatches() throws {
        let fileName = "test.csv"
        let viewModel = FileContentViewModel(data: nil, fileName: fileName)
        XCTAssertEqual(fileName, viewModel.fileName)
    }

    func testShowingAlertWhenWrongData() async throws {
        let viewModel = FileContentViewModel(data: "wrongData".data(using: .utf8), fileName: nil)
        await viewModel.loadData()
        XCTAssertTrue(viewModel.showingAlert)
    }
    
    func testLoadNextPageDefaultPageSize() async throws {
        let viewModel = FileContentViewModel(data: properCsv.data(using: .utf8), fileName: nil)
        await viewModel.loadData(limit: 1)
        XCTAssertEqual(1, viewModel.users.count)
        
        await viewModel.loadNextPage()
        
        XCTAssertEqual(3, viewModel.users.count)
    }
    
    func testLoadNextPageSmallPageSize() async throws {
        let viewModel = FileContentViewModel(data: properCsv.data(using: .utf8), fileName: nil)
        await viewModel.loadData(limit: 0)
        await viewModel.loadNextPage(limit: 1)
        
        XCTAssertEqual(1, viewModel.users.count)
    }
    
    func testLoadNextPageSmallPageSizeMultiple() async throws {
        let viewModel = FileContentViewModel(data: properCsv.data(using: .utf8), fileName: nil)
        await viewModel.loadData(limit: 0)
        
        for index in 1..<4 {
            await viewModel.loadNextPage(limit: 1)
            XCTAssertEqual(index, viewModel.users.count)
        }
    }
}
