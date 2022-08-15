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
    public typealias FileReaderCompletionHandler = (Result<[FileDataHolder], Error>) -> Void
    public typealias ButtonContent = () -> Content
    
    let types: [UTType]
    let allowMultiple: Bool
    let completionHandler: FileReaderCompletionHandler
    let content: ButtonContent
    
    @ObservedObject var viewModel: FileReaderViewModel
    
    public init(
        types: [UTType],
        allowMultiple: Bool,
        completionHandler: @escaping FileReaderCompletionHandler,
        @ViewBuilder content: @escaping ButtonContent
    ) {
        self.types = types
        self.allowMultiple = allowMultiple
        self.completionHandler = completionHandler
        self.content = content
        self.viewModel = FileReaderViewModel()
    }
    
    public var body: some View {
        LoadingView(
            isShowing: $viewModel.isProcessing,
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
    }
}

struct FileReader_Previews: PreviewProvider {
    static var previews: some View {
        FileReader(types: [.commaSeparatedText], allowMultiple: false, completionHandler: { _ in
            
        }, content: {
            Text("Pick & read file")
        })
    }
}
