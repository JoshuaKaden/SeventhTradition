//
//  OtherExpenseView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct OtherExpenseView: View {
    
    @State var otherExpense: OtherExpense?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditing: Bool = false
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var info: String = ""
    
    private var hasChange: Bool {
        guard let otherExpense else {
            return false
        }
        if amount != otherExpense.amount ||
            date != otherExpense.date ||
            info != otherExpense.info
        {
            return true
        }
        return false
    }
    
    var body: some View {
        if otherExpense == nil {
            ContentUnavailableView("No expense selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        } else if let otherExpense {
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
                    Section("Info") {
                        TextField("", text: $info)
                    }
                } else {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.footnote)
                            Text(otherExpense.date.formatted())
                        }
                        VStack(alignment: .leading) {
                            Text("Amount")
                                .font(.footnote)
                            Text(otherExpense.amount.formatted(.currency(code: currencyCode)))
                        }
                        VStack(alignment: .leading) {
                            Text("Info")
                                .font(.footnote)
                            Text(otherExpense.info)
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
        if let otherExpense {
            amount = otherExpense.amount
            date = otherExpense.date
            info = otherExpense.info
        }
    }
    
    private func assignToModel() {
        if let otherExpense {
            otherExpense.amount = amount
            otherExpense.date = date
            otherExpense.info = info
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
