//
//  FileListView.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import SwiftUI
import FileReader

struct FileListView: View {
    @ObservedObject var viewModel: FileListViewModel
    
    init(files: [FileReadResult]) {
        viewModel = FileListViewModel(files: files)
    }
    
    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Text("file_list_header_text".localized())
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    successList
                    
                    errorList
                }
            }
        }
        .navigationTitle("Pick file")
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("generic_error_title".localized()),
                message: Text("file_list_error_text".localized()),
                dismissButton: .default(Text("ok".localized())))
        }
    }
    
    @ViewBuilder var errorList: some View {
        let errorReads = viewModel.errorReads
        
        if !errorReads.isEmpty {
            LazyVStack(spacing: 0) {
                HeaderView(title: "file_list_error_header".localized())
                
                ForEach(viewModel.errorReads, id: \.id) { file in
                    Button {
                        viewModel.onRowClickAction(file.id)
                    } label: {
                        FileRow(text: file.name, showChevron: false)
                    }

                    
                }
            }
            .padding(.bottom, -1) // For some reason, there is extra padding on the bottom of the LazyVStack
            .background(Color.headerBackground)
        }
    }
    
    @ViewBuilder var successList: some View {
        LazyVStack(spacing: 0) {
            HeaderView(title: "file_list_success_header".localized())
            
            ForEach(viewModel.succesfullReads, id: \.id) { file in
                Button {
                    viewModel.onRowClickAction(file.id)
                } label: {
                    FileRow(text: file.name, showChevron: true)
                }
            }
        }
        .padding(.bottom, -1) // For some reason, there is extra padding on the bottom of the LazyVStack
        .background(Color.headerBackground)
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView(files: [])
    }
}
