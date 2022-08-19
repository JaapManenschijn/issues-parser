//
//  FileReader.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import UniformTypeIdentifiers
import Common

/// A View that can be used to show a UIDocumentPicker and receive the data of the picked files in a completion handler
public struct FileReaderButton<Content: View>: View {
    public typealias ButtonContent = () -> Content
    
    let types: [UTType]
    let allowMultiple: Bool
    let content: ButtonContent
    
    @ObservedObject var viewModel: FileReaderButtonViewModel
    @Binding var result: [FileReadResult]
    @Binding var isLoading: Bool
    
    /// Initializes the FileReader view
    /// - Parameters:
    ///   - types: The types of files you want to be able to pick
    ///   - allowMultiple: Whether or not to allow picking multiple files
    ///   - result: A binding to receive the results on
    ///   - isLoading: A binding to indicate when the FileReader is loading (processing) the files
    ///   - content: The content of the FileReader. Will be wrapped in a button
    public init(
        types: [UTType],
        allowMultiple: Bool,
        result: Binding<[FileReadResult]>,
        isLoading: Binding<Bool>,
        @ViewBuilder content: @escaping ButtonContent
    ) {
        self.types = types
        self.allowMultiple = allowMultiple
        self.content = content
        self._result = result
        self._isLoading = isLoading
        self.viewModel = FileReaderButtonViewModel()
    }
    
    public var body: some View {
        Button(
            action: viewModel.onButtonAction,
            label: {
                content()
            }
        )
        .disabled(viewModel.isPresented)
        .sheet(isPresented: $viewModel.isPresented) {
            DocumentPickerRepresentable(types: types, allowMultiple: allowMultiple) { urls in
                isLoading = true
                Task {
                    let results = try await viewModel.onFilesPicked(urls: urls)
                    // We're simulating a small delay here, just to have a meaningful isLoading value
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    isLoading = false
                    result = results
                }
            }
        }
    }
}

struct FileReader_Previews: PreviewProvider {
    static var previews: some View {
        FileReaderButton(types: [.commaSeparatedText], allowMultiple: false, result: .constant([]), isLoading: .constant(false), content: {
            Text("Pick & read file")
        })
    }
}
