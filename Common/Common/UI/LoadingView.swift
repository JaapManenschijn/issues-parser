//
//  LoadingView.swift
//  Common
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI

public struct LoadingView<Content: View>: View {
    public typealias LoadingViewContent = () -> Content
    
    var isShowing: Bool
    let title: String
    var content: LoadingViewContent
    
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
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    Text(title)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.primaryBackground)
                .foregroundColor(Color.primaryText)
                .cornerRadius(20)
                .shadow(color: Color.primaryShadow, radius: 3, x: 0, y: 0)
                .opacity(self.isShowing ? 1 : 0)
                
            }
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
