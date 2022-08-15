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
    
    public init(
        types: [UTType],
        allowMultiple: Bool,
        result: Binding<[FileReadResult]>,
        @ViewBuilder content: @escaping ButtonContent
    ) {
        self.types = types
        self.allowMultiple = allowMultiple
        self.content = content
        self._result = result
        self.viewModel = FileReaderViewModel()
    }
    
    public var body: some View {
        LoadingView(
            isShowing: viewModel.isProcessing,
            title: "Processing files") {
                Button(
                    action: viewModel.onButtonAction,
                    label: {
                        content()
                    }
                )
                .disabled(viewModel.isPresented)
            }
            .sheet(isPresented: $viewModel.isPresented) {
                DocumentPickerRepresentable(types: types, allowMultiple: allowMultiple) { urls in
                    viewModel.onFilesPicked(urls: urls)
                }
            }
            .onChange(of: viewModel.results) { newValue in
                result = newValue
            }
    }
}

struct FileReader_Previews: PreviewProvider {
    static var previews: some View {
        FileReader(types: [.commaSeparatedText], allowMultiple: false, result: .constant([]), content: {
            Text("Pick & read file")
        })
    }
}
