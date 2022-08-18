//
//  FileReader.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import UniformTypeIdentifiers
import Common

public struct FileReader<Content: View>: View {
    public typealias ButtonContent = () -> Content
    
    let types: [UTType]
    let allowMultiple: Bool
    let content: ButtonContent
    
    @ObservedObject var viewModel: FileReaderViewModel
    @Binding var result: [FileReadResult]
    @Binding var isLoading: Bool
    
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
        self.viewModel = FileReaderViewModel()
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
        FileReader(types: [.commaSeparatedText], allowMultiple: false, result: .constant([]), isLoading: .constant(false), content: {
            Text("Pick & read file")
        })
    }
}
