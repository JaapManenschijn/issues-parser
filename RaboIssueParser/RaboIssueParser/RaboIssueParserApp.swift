//
//  RaboIssueParserApp.swift
//  RaboIssueParser
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import IssuesUI

@main
struct RaboIssueParserApp: App {
    var body: some Scene {
        WindowGroup {
            getView()
                .onAppear(perform: {
                    setupAppearance()
                })
        }
    }
    
    private func getView() -> some View {
        return IssuesRouter.mainView
    }
    
    private func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navigationBackground

        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.titleText
        ]

        appearance.titleTextAttributes = attrs

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }
}
