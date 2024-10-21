//
//  CollectionView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct CollectionView: View {
    
    @State var collection: Collection?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditing: Bool = false
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    
    private var hasChange: Bool {
        guard let collection else {
            return false
        }
        if amount != collection.amount ||
            date != collection.date
        {
            return true
        }
        return false
    }
    
    var body: some View {
        if collection == nil {
            ContentUnavailableView("No collection selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        } else if let collection {
            Form {
                if isEditing {
                    Section("Amount") {
                        TextField("", value: $amount, format: .number)
#if os(iOS)
                            .keyboardType(.decimalPad)
#endif
                    }
                    Section("Date") {
                        DatePicker("", selection: $date)
                    }
                } else {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.footnote)
                            Text(collection.date.formatted())
                        }
                        VStack(alignment: .leading) {
                            Text("Amount")
                                .font(.footnote)
                            Text(collection.amount.formatted(.currency(code: currencyCode)))
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .task {
                assignFromModel()
            }
            .animation(nil, value: isEditing)
            .toolbar {
                if isEditing == true {
                    ToolbarItem {
                        Button(action: cancelEdits) {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem {
                        Button(action: save) {
                            Text("Save")
                        }
                        .disabled(!hasChange)
                    }
                } else {
                    ToolbarItem {
                        Button(action: toggleIsEditing) {
                            Text("Edit")
                        }
                    }
                }
            }
        }
    }
    
    private func assignFromModel() {
        if let collection {
            amount = collection.amount
            date = collection.date
        }
    }
    
    private func assignToModel() {
        if let collection {
            collection.amount = amount
            collection.date = date
        }
    }
    
    private func cancelEdits() {
        withAnimation {
            assignFromModel()
            isEditing = false
        }
    }
    
    private func save() {
        withAnimation {
            assignToModel()
            isEditing = false
        }
        try? modelContext.save()
    }
    
    private func toggleIsEditing() {
        withAnimation {
            isEditing.toggle()
        }
    }
    
}
