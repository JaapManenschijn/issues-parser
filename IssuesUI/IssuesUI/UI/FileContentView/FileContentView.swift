//
//  FileContentView.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import SwiftUI
import Common

struct FileContentView: View {
    @ObservedObject var viewModel: FileContentViewModel
    @Environment(\.presentationMode) var presentation
    
    init(data: Data?, fileName: String?) {
        viewModel = FileContentViewModel(data: data, fileName: fileName)
    }
    
    var body: some View {
        LoadingView(isShowing: viewModel.isLoading, title: "processing".localized()) {
            ZStack {
                Color.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.users, id: \.id) { user in
                            UserRow(user: user)
                        }
                        
                        if viewModel.hasMoreData {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .secondaryBackground))
                                .onAppear() {
                                    Task {
                                        await viewModel.loadNextPage()
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(viewModel.fileName ?? "")
            .onAppear {
                Task {
                    await viewModel.loadData()
                }
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(
                    title: Text("generic_error_title".localized()),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("ok".localized())) {
                        presentation.wrappedValue.dismiss()
                    })
            }
        }
    }
}

struct FileContentView_Previews: PreviewProvider {
    static var previews: some View {
        FileContentView(data: "test".data(using: .utf8)!, fileName: "Issues.csv")
    }
}
