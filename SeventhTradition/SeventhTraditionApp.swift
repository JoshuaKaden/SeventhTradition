//
//  SeventhTraditionApp.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import SwiftUI
import SwiftData

@main
struct SeventhTraditionApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Collection.self,
            GroupConscienceGoal.self,
            GroupConsciencePayment.self,
            Meeting.self,
            OtherIncome.self,
            RentPayment.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
