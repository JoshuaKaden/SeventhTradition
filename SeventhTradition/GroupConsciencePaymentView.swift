//
//  GroupConsciencePaymentView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct GroupConsciencePaymentView: View {
    
    @State var payment: GroupConsciencePayment?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditing: Bool = false
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var method: String = ""
    @State private var who: String = ""

    private var hasChange: Bool {
        guard let payment else {
            return false
        }
        if amount != payment.amount ||
            date != payment.date ||
            method != payment.method ||
            who != payment.who
        {
            return true
        }
        return false
    }
    
    var body: some View {
        if payment == nil {
            ContentUnavailableView("No income selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        } else if let payment {
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
                    Section("Method") {
                        TextField("", text: $method)
                    }
                    Section("Who") {
                        TextField("", text: $who)
                    }
                } else {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.footnote)
                            Text(payment.date.formatted())
                        }
                        VStack(alignment: .leading) {
                            Text("Amount")
                                .font(.footnote)
                            Text(payment.amount.formatted(.currency(code: currencyCode)))
                        }
                        VStack(alignment: .leading) {
                            Text("Method")
                                .font(.footnote)
                            Text(payment.method)
                        }
                        VStack(alignment: .leading) {
                            Text("Who")
                                .font(.footnote)
                            Text(payment.who)
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
        if let payment {
            amount = payment.amount
            date = payment.date
            method = payment.method
            who = payment.who
        }
    }
    
    private func assignToModel() {
        if let payment {
            payment.amount = amount
            payment.date = date
            payment.method = method
            payment.who = who
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
