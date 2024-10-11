//
//  ContentView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var meetings: [Meeting]

    @State private var selectedMeeting: Meeting?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedMeeting) {
                ForEach(meetings) { meeting in
                    NavigationLink(meeting.name, value: meeting)
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if selectedMeeting != nil {
                MeetingView(meeting: $selectedMeeting)
            } else {
                Text("Select a meeting")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newName = "Friday"
            let newMeeting = Meeting(name: newName)
            modelContext.insert(newMeeting)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(meetings[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Meeting.self, inMemory: true)
}
