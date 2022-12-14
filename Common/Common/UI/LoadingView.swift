//
//  LoadingView.swift
//  Common
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI

/// A View that can be used to show a Loading popup
public struct LoadingView<Content: View>: View {
    public typealias LoadingViewContent = () -> Content
    
    var isShowing: Bool
    let title: String
    var content: LoadingViewContent
    private let width: CGFloat = 200
    private var height: CGFloat {
        width * 0.66
    }
    
    /// Initializes the LoadinView
    /// - Parameters:
    ///   - isShowing: A boolean to indicate whether or not the loading popup is showing
    ///   - title: A String to show in the loading popup
    ///   - content: The content that the loading popup is shown on top of
    public init(
        isShowing: Bool,
        title: String,
        @ViewBuilder content: @escaping LoadingViewContent
    ) {
        self.isShowing = isShowing
        self.title = title
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            self.content()
                .disabled(self.isShowing)
                .blur(radius: self.isShowing ? 3 : 0)
            
            VStack {
                Text(title)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .alertText))
            }
            .frame(width: width, height: height)
            .background(Color.alertBackground)
            .foregroundColor(Color.alertText)
            .cornerRadius(20)
            .shadow(color: Color.alertShadow, radius: 3, x: 0, y: 0)
            .opacity(self.isShowing ? 1 : 0)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: true, title: "Loading...") {
            Text("Content view")
        }
    }
}
