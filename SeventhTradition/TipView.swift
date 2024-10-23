//
//  TipView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/22/24.
//

import StoreKit
import SwiftUI

struct TipView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Text("If you've found 7th Tradition useful, tips are always appreciated!")
                .font(.callout)
                .italic()
            ProductView(id: "com.sweetheartsoftware.seventhtradition2024.tipOneDollar")
                .productViewStyle(.compact)
            ProductView(id: "com.sweetheartsoftware.seventhtradition2024.tipTwoDollars")
                .productViewStyle(.compact)
            ProductView(id: "com.sweetheartsoftware.seventhtradition2024.tipFiveDollars")
                .productViewStyle(.compact)
        }
        .toolbar {
            Button {
                dismiss()
            } label: {
                Image(systemName: "x.circle")
            }
        }
        .navigationTitle("Leave a Tip")
    }
}

#Preview {
    TipView()
}
