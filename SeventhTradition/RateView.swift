//
//  RateView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/22/24.
//

import StoreKit
import SwiftUI

struct RateView: View {
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            Text("If 7th Tradition is useful for you, please consider leaving a high rating and positive review")
                .font(.footnote)
            Button("Rate & Review", action: requestReviewManually)
                .buttonStyle(.borderless)
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
    
    /// - Tag: ManualReviewRequest
    private func requestReviewManually() {
        // Replace the placeholder value below with the App Store ID for your app.
        // You can find the App Store ID in your app's product URL.
        let url = "https://apps.apple.com/app/id6737234146?action=write-review"
        
        guard let writeReviewURL = URL(string: url) else {
            fatalError("Expected a valid URL")
        }
        
        openURL(writeReviewURL)
    }
}

#Preview {
    RateView()
}
