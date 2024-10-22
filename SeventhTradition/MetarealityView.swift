//
//  MetarealityView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/22/24.
//

import SwiftUI

struct MetarealityView: View {
    var body: some View {
        Form {
//            Section {
//                NavigationLink("About and Help", destination: AboutView())
//                    .padding(8)
//                NavigationLink("Technical Details", destination: TechView())
//                    .padding(8)
//            }
            
            Section {
                NavigationLink("Leave a Tip", destination: TipView())
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
        .navigationTitle("7th Tradition")
    }
}

#Preview {
    MetarealityView()
}
