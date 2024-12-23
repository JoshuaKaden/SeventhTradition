//
//  AboutView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/24/24.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        Form {
            Section {
                Text("About 7th Tradition")
                    .bold()
                HStack {
                    Image("IconImageBig")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        if let version = findAppVersion() {
                            Text("Version")
                                .font(.footnote)
                            Text(version)
                                .monospaced()
                        }
                    }
                    .padding(.leading, 5)
                }
                .padding(8)
            }

            Section("Overview") {
                Text("7th Tradition is a minimalist app to simplify your treasury service.")
                    .padding(8)
                Text("Create a meeting, with beginning balance, rent, and prudent reserve. Record collections and other income, as well as rent payments and other expenses. Set up Group Conscience goals, and optionally auto-generate payment records.")
                    .padding(8)
                Text("All data can be viewed on a treasurer's report, for any start or end date, with starting/ending balances.")
                    .padding(8)
                Text("While specifically designed to support the Seventh Tradition, this app is not officially endorsed by any 12-step group.")
                    .padding(8)
            }
            
            Section("Technical Details") {
                Text("7th Tradition was created in 2024 by Joshua Kaden.")
                    .padding(8)
                Text("The code uses SwiftUI and SwiftData, and is for iOS 18 (and beyond).")
                    .padding(8)
                Text("If you're curious about the source code, feel free to have a look! [The repository is on GitHub](https://github.com/JoshuaKaden/SeventhTradition), and is named `JoshuaKaden/SeventhTradition`.")
                    .padding(8)
            }
            
        }
        .navigationTitle("About the app")
    }
    
    private func findAppVersion() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
}

#Preview {
    AboutView()
}
