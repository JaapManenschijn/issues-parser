//
//  DocumentPickerRepresentable.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    typealias PickerCompletionHandler = (_ urls: [URL]) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    let types: [UTType]
    let allowMultiple: Bool
    let completionHandler: PickerCompletionHandler
    
    init(types: [UTType], allowMultiple: Bool, onPicked completionHandler: @escaping PickerCompletionHandler) {
        self.types = types
        self.allowMultiple = allowMultiple
        self.completionHandler = completionHandler
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText], asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // Noop
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

extension DocumentPickerRepresentable {
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerRepresentable
        
        init(parent: DocumentPickerRepresentable) {
            self.parent = parent
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.completionHandler(urls)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
