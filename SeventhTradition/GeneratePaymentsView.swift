//
//  GeneratePaymentsView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/21/24.
//

import SwiftData
import SwiftUI

struct GeneratePaymentsView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \GroupConscienceGoal.type) private var groupConscienceGoals: [GroupConscienceGoal]
    
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
                            } else {
                                Text(goal.amount.formatted(.currency(code: currencyCode)))
                            }
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("GC Auto Pay")
        }
    }
}
