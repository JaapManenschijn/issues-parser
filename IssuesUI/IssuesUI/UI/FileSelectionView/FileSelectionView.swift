//
//  FileSelectionView.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import SwiftUI
import Common
import FileReader

struct FileSelectionView: View {
    @StateObject var viewModel: FileSelectionViewModel = FileSelectionViewModel()
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: viewModel.isLoading, title: "processing".localized()) {
                ZStack {
                    Color.primaryBackground
                        .ignoresSafeArea()
                    
                    VStack(alignment: .center, spacing: 24) {
                        NavigationLink(
                            destination: FileListView(files: viewModel.fileReaderResults),
                            isActive: $viewModel.shouldNavigate) { EmptyView()
                            }
                        
                        Text("select_file_text".localized())
                            .multilineTextAlignment(.center)
                        
                        FileReaderButton(
                            types: [.commaSeparatedText],
                            allowMultiple: true,
                            result: $viewModel.fileReaderResults,
                            isLoading: $viewModel.isLoading) {
                                ZStack {
                                    Color.buttonBackground
                                    
                                    HStack {
                                        Image(systemName: "folder.badge.plus")
                                        Text("select_file_button".localized())
                                    }
                                    .foregroundColor(.buttonText)
                                    .padding()
                                }
                                
                                .fixedSize()
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                                
                            }
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                }
                .navigationTitle("select_file_title".localized())
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.buttonText)
    }
}

struct FileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FileSelectionView()
    }
}
