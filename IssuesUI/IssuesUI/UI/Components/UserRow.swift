//
//  UserRow.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import SwiftUI
import CSVParser

struct UserModel {
    let id: UUID
    let name: String
    let issueCount: Int
    let birthDate: String
}

struct UserRow: View {
    let user: UserModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(String(format: "user_name".localized(), user.name) )
                Text(String(format: "user_dob".localized(), user.birthDate) )
            }
            Spacer()
            VStack {
                Text("user_issues".localized())
                Text("\(user.issueCount)")
            }
        }
        .foregroundColor(.secondaryText)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.secondaryBackground)
        .cornerRadius(6)
        .shadow(radius: 3)
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: UserModel(id: UUID(), name: "Test Tester", issueCount: 12, birthDate: "12-01-2000"))
    }
}
