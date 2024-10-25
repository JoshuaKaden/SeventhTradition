//
//  ContentView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import SwiftUI
import SwiftData

private struct CurrencyCodeEnvironmentKey: EnvironmentKey {
    static let defaultValue: String = "USD"
}

extension EnvironmentValues {
    var currencyCode: String {
        get { self[CurrencyCodeEnvironmentKey.self] }
        set { self[CurrencyCodeEnvironmentKey.self] = newValue }
    }
}

private struct MeetingEnvironmentKey: EnvironmentKey {
    static let defaultValue: Meeting? = nil
}

extension EnvironmentValues {
    var meeting: Meeting? {
        get { self[MeetingEnvironmentKey.self] }
        set { self[MeetingEnvironmentKey.self] = newValue }
    }
}

struct ContentView: View {
    @Environment(\.locale) private var locale
    @Environment(\.modelContext) private var modelContext
    
    @Query private var meetings: [Meeting]

    @State private var selectedMeeting: Meeting?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedMeeting) {
                if meetings.isEmpty {
                    ContentUnavailableView("Welcome to 7th Tradition", image: "IconImage64")
                }
                ForEach(meetings) { meeting in
                    NavigationLink(meeting.name, value: meeting)
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: MetarealityView()) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        } detail: {
            NavigationStack {
                MeetingView()
            }
        }
        .environment(\.currencyCode, locale.currency?.identifier ?? "USD")
        .environment(\.meeting, selectedMeeting)
    }

    private func addItem() {
        withAnimation {
            let newMeeting = Meeting(id: UUID(), name: "New Meeting")
            modelContext.insert(newMeeting)
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Meeting.self, inMemory: true)
}
