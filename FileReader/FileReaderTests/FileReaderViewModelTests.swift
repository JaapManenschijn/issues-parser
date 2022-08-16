//
//  FileReaderViewModelTests.swift
//  FileReaderTests
//
//  Created by J Manenschijn on 15/08/2022.
//

import XCTest
import Combine
@testable import FileReader

class FileReaderViewModelTests: XCTestCase {
    private var viewModel: FileReaderViewModel = FileReaderViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        viewModel = FileReaderViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }

    func testPresentedTrueOnButtonAction() throws {
        viewModel.onButtonAction()
        XCTAssertTrue(viewModel.isPresented)
    }

    func testPresentedToggledOnceOnButtonAction() throws {
        let presentedPublisher = viewModel.$isPresented
        
        var counter = 0
        presentedPublisher
            .dropFirst()
            .sink { _ in
                counter += 1
            }
            .store(in: &cancellables)
        
        viewModel.onButtonAction()
        viewModel.onButtonAction()
        XCTAssertEqual(counter, 1)
    }

    func testProcessingFalseAfterFilesPicker() throws {
        viewModel.onButtonAction()
        XCTAssertTrue(viewModel.isPresented)
        
        let expect = expectation(description: "results")
        viewModel.$results
            .dropFirst()
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.onFilesPicked(urls: [URL(string: "https://www.google.com")!])
        wait(for: [expect], timeout: 10)
        XCTAssertFalse(viewModel.isProcessing)
    }
    
    func testProcessingTrueOnFilesPicked() throws {
        viewModel.$isProcessing
            .dropFirst()
            .sink { newValue in
                XCTAssertTrue(newValue)
            }
            .store(in: &cancellables)
        viewModel.onFilesPicked(urls: [URL(string: "https://www.google.com")!])
    }
    
    func testErrorReadResult() throws {
        var didReceiveError = false
        
        let expect = expectation(description: "results")
        viewModel.$results
            .dropFirst()
            .sink { results in
                if let first = results.first {
                    switch first.result {
                    case .failure(_):
                        didReceiveError = true
                    default:
                        break
                    }
                }
                expect.fulfill()
            }
            .store(in: &cancellables)
        viewModel.onFilesPicked(urls: [URL(string: "file:///non_existing_file.pdf")!])
        wait(for: [expect], timeout: 10)
        XCTAssertTrue(didReceiveError)
    }
    
    func testSuccessReadResult() throws {
        var didReceiveError = false
        
        let expect = expectation(description: "results")
        viewModel.$results
            .dropFirst()
            .sink { results in
                if let first = results.first {
                    switch first.result {
                    case .failure(_):
                        didReceiveError = true
                    default:
                        break
                    }
                }
                expect.fulfill()
            }
            .store(in: &cancellables)
        viewModel.onFilesPicked(urls: [URL(string: "https://www.google.com")!])
        wait(for: [expect], timeout: 10)
        XCTAssertFalse(didReceiveError)
    }
}
