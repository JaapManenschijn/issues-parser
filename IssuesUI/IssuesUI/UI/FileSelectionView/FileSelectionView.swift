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
    @ObservedObject var viewModel: FileSelectionViewModel = FileSelectionViewModel()
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: viewModel.isLoading, title: "processing".localized()) {
                ZStack {
                    Color.primaryBackground
                        .ignoresSafeArea()
                    
                    VStack(alignment: .center, spacing: 24) {
                        Text("select_file_text".localized())
                            .multilineTextAlignment(.center)
                        
                        FileReader(
                            types: [.commaSeparatedText],
                            allowMultiple: true,
                            result: $viewModel.fileReaderResults,
                            isLoading: $viewModel.isLoading) {
                            HStack {
                                Image(systemName: "folder.badge.plus")
                                Text("select_file_button".localized())
                            }
                            .frame(maxWidth: .infinity)
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
    }
}

struct FileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FileSelectionView()
    }
}
