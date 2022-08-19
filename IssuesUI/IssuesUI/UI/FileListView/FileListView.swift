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
                    
                    getFileList(header: "file_list_success_header".localized(),
                                files: viewModel.succesfullReads,
                                showChevron: true)
                    
                    getFileList(header: "file_list_error_header".localized(),
                                files: viewModel.errorReads,
                                showChevron: false)
                    
                    NavigationLink(
                        destination: FileContentView(data: viewModel.selectedFileData, fileName: viewModel.selectedFileName),
                        isActive: $viewModel.shouldNavigate) { EmptyView()
                        }
                }
            }
        }
        .navigationTitle("file_list_title".localized())
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("generic_error_title".localized()),
                message: Text("file_list_error_text".localized()),
                dismissButton: .default(Text("ok".localized())))
        }
    }
    
    @ViewBuilder func getFileList(header: String, files: [FileModel], showChevron: Bool) -> some View {
        if !files.isEmpty {
            LazyVStack(spacing: 0) {
                HeaderView(title: header)
                
                ForEach(files, id: \.id) { file in
                    Button {
                        viewModel.onRowClickAction(file.id)
                    } label: {
                        FileRow(text: file.name, showChevron: showChevron)
                    }
                }
            }
            .padding(.bottom, -1) // For some reason, there is extra padding on the bottom of the LazyVStack
            .background(Color.headerBackground)
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView(files: [])
    }
}
