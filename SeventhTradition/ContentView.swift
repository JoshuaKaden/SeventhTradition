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

struct ContentView: View {
    @Environment(\.locale) private var locale
    @Environment(\.modelContext) private var modelContext
    
    @Query private var meetings: [Meeting]

    @State private var selectedMeeting: Meeting?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedMeeting) {
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
                NavigationLink(destination: MetarealityView()) {
                    Image(systemName: "questionmark.circle")
                }
            }
        } detail: {
            NavigationStack {
                if selectedMeeting != nil {
                    MeetingView(meeting: $selectedMeeting)
                } else {
                    Text("Select a meeting")
                }
            }
        }
        .environment(\.currencyCode, locale.currency?.identifier ?? "USD")
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
