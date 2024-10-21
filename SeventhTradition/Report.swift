//
//  Report.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/21/24.
//

import SwiftData
import SwiftUI

struct Report: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.currencyCode) private var currencyCode
    
    @Query(sort: \Collection.date, order: .reverse) private var collections: [Collection]
    @Query(sort: \GroupConsciencePayment.date, order: .reverse) private var groupConsciencePayments: [GroupConsciencePayment]
    @Query(sort: \OtherExpense.date, order: .reverse) private var otherExpenses: [OtherExpense]
    @Query(sort: \OtherIncome.date, order: .reverse) private var otherIncomes: [OtherIncome]
    @Query(sort: \RentPayment.date, order: .reverse) private var rentPayments: [RentPayment]
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        
        if let meeting {

            let collectionsTotalBB = collections
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let groupConscienceTotalBB = groupConsciencePayments
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let otherExpensesTotalBB = otherExpenses
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let otherIncomeTotalBB = otherIncomes
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let rentPaymentsTotalBB = rentPayments
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let gotBB = collectionsTotalBB + otherIncomeTotalBB
            let spentBB = rentPaymentsTotalBB + groupConscienceTotalBB + otherExpensesTotalBB
            let startingBalance = meeting.beginningBalance + gotBB - spentBB
            
            let collectionsTotal = collections
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let groupConscienceTotal = groupConsciencePayments
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let otherExpensesTotal = otherExpenses
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let otherIncomeTotal = otherIncomes
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let rentPaymentsTotal = rentPayments
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
                .map { $0.amount }
                .reduce(0, +)

            let got = collectionsTotal + otherIncomeTotal
            let spent = rentPaymentsTotal + groupConscienceTotal + otherExpensesTotal
            let endingBalance = startingBalance + got - spent - meeting.prudentReserve
            
            List {
                DatePicker("Start date", selection: $startDate)
                DatePicker("End date", selection: $endDate)
                
                HStack {
                    Text("Starting Balance")
                    Spacer()
                    Text(startingBalance.formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
                HStack {
                    Text("Collections")
                    Spacer()
                    Text(collectionsTotal.formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
                HStack {
                    Text("Other Income")
                    Spacer()
                    Text(otherIncomeTotal.formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
                HStack {
                    Text("Rent")
                    Spacer()
                    Text((rentPaymentsTotal * -1).formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
                HStack {
                    Text("Other Expenses")
                    Spacer()
                    Text((otherExpensesTotal * -1).formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
                HStack {
                    Text("Prudent Reserve")
                    Spacer()
                    Text((meeting.prudentReserve * -1).formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
                HStack {
                    Text("Group Conscience")
                    Spacer()
                    Text((groupConscienceTotal * -1).formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
                HStack {
                    Text("Ending Balance")
                    Spacer()
                    Text(endingBalance.formatted(.currency(code: currencyCode)))
                        .monospaced()
                }
            }
            .navigationTitle("Report")
        }
    }
}
