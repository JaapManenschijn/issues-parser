//
//  HeaderView.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 16)
                .padding(.vertical, 4)
                .foregroundColor(.headerText)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.headerBackground)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Test header")
    }
}
