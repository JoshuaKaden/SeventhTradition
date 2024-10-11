//
//  MeetingView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import SwiftUI

struct MeetingView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditing: Bool = false
    @State private var name: String = ""
    
    var body: some View {
        if let meeting {
            Form {
                if isEditing == true {
                    Section("Name") {
                        TextField(text: $name, label: {})
                    }
                } else {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.footnote)
                            Text(meeting.name)
                                .padding(.bottom)
                        }
                        VStack(alignment: .leading) {
                            Text("Meeting ID")
                                .font(.footnote)
                            Text(meeting.id.uuidString)
                                .font(.footnote)
                        }
                    }
                }
            }
            .task {
                name = meeting.name
            }
            .animation(nil, value: isEditing)
            .toolbar {
                if isEditing == true {
                    ToolbarItem {
                        Button(action: cancelEdits) {
                            Label("Cancel", systemImage: "arrowshape.backward")
                        }
                    }
                    ToolbarItem {
                        Button(action: saveMeeting) {
                            Label("Save", systemImage: "square.and.arrow.down")
                        }
                    }
                } else {
                    ToolbarItem {
                        Button(action: toggleIsEditing) {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                    }
                }
            }
        } else {
            ContentUnavailableView("No meeting selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        }
    }
    
    private func cancelEdits() {
        if let meeting {
            name = meeting.name
        }
        toggleIsEditing()
    }
    
    private func saveMeeting() {
        if let meeting {
            withAnimation {
                meeting.name = name
                isEditing = false
            }
        }
    }
    
    private func toggleIsEditing() {
        withAnimation {
            isEditing.toggle()
        }
    }
}
