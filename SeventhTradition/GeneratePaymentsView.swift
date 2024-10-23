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
    
    @State private var isPresentingConfirm = false
    
    var body: some View {
        if groupConscienceGoals.isEmpty {
            ContentUnavailableView("This will be available once you have created some group conscience goals", systemImage: "bubble.left.and.exclamationmark.bubble.right")
                .navigationTitle("GC Auto Pay")
        } else {
            let treasuryBalance = meeting?.treasuryBalance ?? 0
            
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
                        Text(treasuryBalance.formatted(.currency(code: currencyCode)))
                            .monospaced()
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
                                let paymentAmount = treasuryBalance * goal.percent
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
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("GC Auto Pay")
        }
    }
    
    private func createPayments() {
        guard let meeting else {
            dismiss()
            return
        }
        
        for goal in groupConscienceGoals.filter({ $0.meeting == meeting }) {
            let paymentAmount: Double
            if goal.isPercent {
                paymentAmount = meeting.treasuryBalance * goal.percent
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
}
