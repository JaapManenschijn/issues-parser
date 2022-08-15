//
//  FileReader.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import UniformTypeIdentifiers

public struct FileReader<Content: View>: View {
    public typealias FileReaderCompletionHandler = (Result<Data, Error>) -> Void
    public typealias ButtonContent = () -> Content
    
    let types: [UTType]
    let allowMultiple: Bool
    let completionHandler: FileReaderCompletionHandler
    let content: ButtonContent
    
    @State private var isPresented: Bool = false
    
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
    }
    
    public var body: some View {
        Button(
            action: {
                if !isPresented { isPresented = true }
            },
            label: {
                content()
            }
        )
        .disabled(isPresented)
        .sheet(isPresented: $isPresented) {
            DocumentPickerRepresentable(types: types, allowMultiple: allowMultiple) { urls in
                print(urls)
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
