//
//  MetarealityView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/22/24.
//

import SwiftUI

struct MetarealityView: View {

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                NavigationLink("About the app", destination: AboutView())
                    .padding(8)
            }
            
            Section {
                NavigationLink("Leave a tip", destination: TipView())
                    .padding(8)
            }
            
            Section {
                RateView()
                    .padding(8)
                    .padding(.bottom, 0)
                    .frame(maxWidth: .infinity)
            }
            
            if let url = URL(string: "mailto:seventhtradition@starbasechill.net") {
                Section {
                    VStack {
                        Text("Your questions and comments are most welcome!")
                            .font(.footnote)
                        Link("Compose Email", destination: url)
                            .padding()
                    }
                    .padding(8)
                    .padding(.bottom, 0)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .toolbar {
            Button {
                dismiss()
            } label: {
                Image(systemName: "x.circle")
            }
        }
        .navigationTitle("7th Tradition")
    }
}

#Preview {
    MetarealityView()
}
