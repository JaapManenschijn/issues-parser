//
//  FileListViewModelTests.swift
//  IssuesUITests
//
//  Created by J Manenschijn on 19/08/2022.
//

import XCTest
import FileReader

class FileListViewModelTests: XCTestCase {
    enum TestError: Error {
        case testFailure
    }
    
    let files: [FileReadResult] = [
        FileReadResult(url: URL(string: "www.google.com/issues.csv")!, result: .success("test".data(using: .utf8)!)),
        FileReadResult(url: URL(string: "www.google.com/issues.csv")!, result: .success("test".data(using: .utf8)!)),
        FileReadResult(url: URL(string: "www.google.com/issues.csv")!, result: .success("test".data(using: .utf8)!)),
        FileReadResult(url: URL(string: "www.google.com/issues.csv")!, result: .failure(TestError.testFailure)),
        FileReadResult(url: URL(string: "www.google.com/issues.csv")!, result: .failure(TestError.testFailure)),
        FileReadResult(url: URL(string: "www.google.com/issues.csv")!, result: .failure(TestError.testFailure))
    ]

    func testSuccesfullReadsAmount() throws {
        let viewModel = FileListViewModel(files: files)
        XCTAssertEqual(3, viewModel.succesfullReads.count)
    }
    
    func testErrorReadsAmount() throws {
        let viewModel = FileListViewModel(files: files)
        XCTAssertEqual(3, viewModel.errorReads.count)
    }

    func testShowingAlertOnErrorRowClick() throws {
        let viewModel = FileListViewModel(files: files)
        if let row = files.last {
            viewModel.onRowClickAction(row.uuid)
            
            XCTAssertTrue(viewModel.showingAlert)
        }
    }
    
    func testNotShowingAlertOnSuccessRowClick() throws {
        let viewModel = FileListViewModel(files: files)
        if let row = files.first {
            viewModel.onRowClickAction(row.uuid)
            
            XCTAssertFalse(viewModel.showingAlert)
        }
    }
    
    func testSelectedFileNameMatchesOnSuccessRowClick() throws {
        let viewModel = FileListViewModel(files: files)
        if let row = files.first {
            viewModel.onRowClickAction(row.uuid)
            
            XCTAssertEqual(row.url.lastPathComponent, viewModel.selectedFileName)
        }
    }
    
    func testSelectedFileDataNotNilOnSuccessRowClick() throws {
        let viewModel = FileListViewModel(files: files)
        if let row = files.first {
            viewModel.onRowClickAction(row.uuid)
            
            XCTAssertNotNil(viewModel.selectedFileData)
        }
    }
    
    func testShouldNavigateOnSuccessRowClick() throws {
        let viewModel = FileListViewModel(files: files)
        if let row = files.first {
            viewModel.onRowClickAction(row.uuid)
            
            XCTAssertTrue(viewModel.shouldNavigate)
        }
    }
}
