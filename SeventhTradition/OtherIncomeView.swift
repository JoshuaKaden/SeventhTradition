//
//  OtherIncomeView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct OtherIncomeView: View {
    
    @State var otherIncome: OtherIncome?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditing: Bool = false
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var info: String = ""
    
    private var hasChange: Bool {
        guard let otherIncome else {
            return false
        }
        if amount != otherIncome.amount ||
            date != otherIncome.date ||
            info != otherIncome.info
        {
            return true
        }
        return false
    }
    
    var body: some View {
        if otherIncome == nil {
            ContentUnavailableView("No income selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        } else if let otherIncome {
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
                            Text(otherIncome.date.formatted())
                        }
                        VStack(alignment: .leading) {
                            Text("Amount")
                                .font(.footnote)
                            Text(otherIncome.amount.formatted(.currency(code: currencyCode)))
                        }
                        VStack(alignment: .leading) {
                            Text("Info")
                                .font(.footnote)
                            Text(otherIncome.info)
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
        if let otherIncome {
            amount = otherIncome.amount
            date = otherIncome.date
            info = otherIncome.info
        }
    }
    
    private func assignToModel() {
        if let otherIncome {
            otherIncome.amount = amount
            otherIncome.date = date
            otherIncome.info = info
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
