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
    private var viewModel: FileReaderButtonViewModel = FileReaderButtonViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        viewModel = FileReaderButtonViewModel()
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
    
    func testErrorReadResult() async throws {
        var didReceiveError = false
        
        let results = try await viewModel.onFilesPicked(urls: [URL(string: "file:///non_existing_file.pdf")!])
        
        if let first = results.first {
            switch first.result {
            case .failure(_):
                didReceiveError = true
            default:
                break
            }
        }
        
        XCTAssertTrue(didReceiveError)
    }
    
    func testSuccessReadResult() async throws {
        var didReceiveError = false
       
        let results = try await viewModel.onFilesPicked(urls: [URL(string: "https://www.google.com")!])
        if let first = results.first {
            switch first.result {
            case .failure(_):
                didReceiveError = true
            default:
                break
            }
        }
        
        XCTAssertFalse(didReceiveError)
    }
}
