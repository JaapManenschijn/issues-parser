//
//  FileRow.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import SwiftUI

struct FileRow: View {
    let text: String
    let showChevron: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack {
                Text(text)
                Spacer()
                if showChevron {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal, 16)
            .foregroundColor(.black)
            
            Spacer()
            
            Divider()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .background(Color.white)
    }
}

struct FileRow_Previews: PreviewProvider {
    static var previews: some View {
        FileRow(text: "issues.csv", showChevron: true)
    }
}
