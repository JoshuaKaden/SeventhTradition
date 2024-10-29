//
//  GeneratePaymentsView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/21/24.
//

import SwiftData
import SwiftUI

struct GeneratePaymentsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.meeting) private var meeting
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \GroupConscienceGoal.type) private var groupConscienceGoals: [GroupConscienceGoal]
    
    @State private var customBalance: Double = 0
    @State private var isEditing: Bool = false
    @State private var isPresentingConfirm = false
    
    var body: some View {
        if groupConscienceGoals.isEmpty {
            ContentUnavailableView("This will be available once you have created some group conscience goals", systemImage: "bubble.left.and.exclamationmark.bubble.right")
                .navigationTitle("GC Auto Pay")
        } else {
            let treasuryBalance = meeting?.treasuryBalance ?? 0
            let calculationBalance = customBalance == 0 ? treasuryBalance < 0 ? 0 : treasuryBalance : customBalance
            
            Form {
                Section {
                    Text("This will create a payment for each goal, when you tap GO")
                        .font(.footnote)
                        .italic()
                }
                
                Section {
                    HStack {
                        Text("Treasury Balance")
                        Spacer()
                        if customBalance <= 0 || customBalance == treasuryBalance {
                            Text(treasuryBalance.formatted(.currency(code: currencyCode)))
                                .monospaced()
                                .bold()
                        } else {
                            Text(treasuryBalance.formatted(.currency(code: currencyCode)))
                                .monospaced()
                        }
                    }
                    
                    if isEditing {
                        VStack(alignment: .leading) {
                            Text("Enter a custom balance here, and it will be used to calculate percentages")
                                .font(.footnote)
                                .italic()
                            TextField("", value: $customBalance, format: .number)
#if os(iOS)
                                .keyboardType(.decimalPad)
#endif
                        }
                    } else {
                        if customBalance > 0 && customBalance != treasuryBalance {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Custom balance")
                                    Text("for percentage calculation")
                                        .font(.footnote)
                                        .italic()
                                }
                                Spacer()
                                Text(customBalance.formatted(.currency(code: currencyCode)))
                                    .monospaced()
                                    .bold()
                            }
                        }
                    }
                    
                    Text("-- Payments to be created --")
                        .font(.footnote)
                    ForEach(groupConscienceGoals.filter({ $0.meeting == meeting })) { goal in
                        HStack {
                            if goal.isPercent {
                                Text("\(goal.type) (\(goal.percent.formatted(.percent)))")
                            } else {
                                Text(goal.type)
                            }
                            Spacer()
                            if goal.isPercent {
                                let paymentAmount = calculationBalance * goal.percent
                                Text(paymentAmount.formatted(.currency(code: currencyCode)))
                                    .monospaced()
                            } else {
                                Text(goal.amount.formatted(.currency(code: currencyCode)))
                                    .monospaced()
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        isPresentingConfirm = true
                    } label: {
                        Text("GO")
                    }
                    .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                        Button("Create these payments?") {
                            createPayments()
                        }
                    }
                    .buttonStyle(.borderless)
                    .disabled(isEditing)
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .formStyle(.grouped)
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
                    }
                } else {
                    ToolbarItem {
                        Button(action: toggleIsEditing) {
                            Text("Edit")
                        }
                    }
                }
            }
            .navigationTitle("GC Auto Pay")
        }
    }
    
    private func createPayments() {
        guard let meeting else {
            dismiss()
            return
        }
        
        let treasuryBalance = meeting.treasuryBalance
        let calculationBalance = customBalance == 0 ? treasuryBalance < 0 ? 0 : treasuryBalance : customBalance
        
        for goal in groupConscienceGoals.filter({ $0.meeting == meeting }) {
            let paymentAmount: Double
            if goal.isPercent {
                paymentAmount = calculationBalance * goal.percent
            } else {
                paymentAmount = goal.amount
            }
            if paymentAmount > 0 {
                let new = GroupConsciencePayment(amount: paymentAmount, date: Date(), method: "", type: goal.type, who: "")
                modelContext.insert(new)
                meeting.groupConsciencePayments?.append(new)
                new.meeting = meeting
            }
        }
        
        meeting.updateSummaries()
        
        try? modelContext.save()
        dismiss()
    }
    
    private func cancelEdits() {
        withAnimation {
//            assignFromModel()
            isEditing = false
        }
    }
    
    private func save() {
        withAnimation {
//            assignToModel()
            isEditing = false
        }
    }
    
    private func toggleIsEditing() {
        withAnimation {
            isEditing.toggle()
        }
    }
}
