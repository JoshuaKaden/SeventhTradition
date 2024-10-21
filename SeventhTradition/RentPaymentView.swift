//
//  RentPaymentView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct RentPaymentView: View {
    
    @State var rentPayment: RentPayment?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext

    @State private var isEditing: Bool = false
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var method: String = ""
    @State private var who: String = ""
    
    private var hasChange: Bool {
        guard let rentPayment else {
            return false
        }
        if amount != rentPayment.amount ||
            date != rentPayment.date ||
            method != rentPayment.method ||
            who != rentPayment.who
        {
            return true
        }
        return false
    }
    
    var body: some View {
        if rentPayment == nil {
            ContentUnavailableView("No rent payment selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        } else if let rentPayment {
            Form {
                if isEditing {
                    Section("Date") {
                        DatePicker("", selection: $date)
                    }
                    Section("Amount") {
                        TextField("", value: $amount, format: .number)
#if os(iOS)
                            .keyboardType(.decimalPad)
#endif
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
                            Text(rentPayment.date.formatted())
                        }
                        VStack(alignment: .leading) {
                            Text("Amount")
                                .font(.footnote)
                            Text(rentPayment.amount.formatted(.currency(code: currencyCode)))
                        }
                        VStack(alignment: .leading) {
                            Text("Method")
                                .font(.footnote)
                            Text(rentPayment.method)
                        }
                        VStack(alignment: .leading) {
                            Text("Who")
                                .font(.footnote)
                            Text(rentPayment.who)
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
        if let rentPayment {
            amount = rentPayment.amount
            date = rentPayment.date
            method = rentPayment.method
            who = rentPayment.who
        }
    }
    
    private func assignToModel() {
        if let rentPayment {
            rentPayment.amount = amount
            rentPayment.date = date
            rentPayment.method = method
            rentPayment.who = who
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
