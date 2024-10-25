//
//  Report.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/21/24.
//

import SwiftData
import SwiftUI

struct Report: View {
        
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.meeting) private var meeting

    @Query(sort: \Collection.date) private var collectionsQuery: [Collection]
    @Query(sort: \GroupConsciencePayment.date) private var groupConsciencePaymentsQuery: [GroupConsciencePayment]
    @Query(sort: \OtherExpense.date) private var otherExpensesQuery: [OtherExpense]
    @Query(sort: \OtherIncome.date) private var otherIncomesQuery: [OtherIncome]
    @Query(sort: \RentPayment.date) private var rentPaymentsQuery: [RentPayment]
    
    @State private var startDate: Date = Date().startDateOfMonth
    @State private var endDate: Date = Date().endDateOfMonth
    
    var body: some View {
        
        if let meeting {

            let collectionsTotalBB = collectionsQuery
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let groupConscienceTotalBB = groupConsciencePaymentsQuery
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let otherExpensesTotalBB = otherExpensesQuery
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let otherIncomeTotalBB = otherIncomesQuery
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let rentPaymentsTotalBB = rentPaymentsQuery
                .filter({ $0.meeting == meeting && $0.date < startDate })
                .map { $0.amount }
                .reduce(0, +)
            
            let gotBB = collectionsTotalBB + otherIncomeTotalBB
            let spentBB = rentPaymentsTotalBB + groupConscienceTotalBB + otherExpensesTotalBB
            let startingBalance = meeting.beginningBalance + gotBB - spentBB
            
            let collections = collectionsQuery
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
            let collectionsTotal = collections
                .map { $0.amount }
                .reduce(0, +)
            
            let groupConsciencePayments = groupConsciencePaymentsQuery
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
            let groupConscienceTotal = groupConsciencePayments
                .map { $0.amount }
                .reduce(0, +)
            
            let otherExpenses = otherExpensesQuery
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
            let otherExpensesTotal = otherExpenses
                .map { $0.amount }
                .reduce(0, +)
            
            let otherIncomes = otherIncomesQuery
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
            let otherIncomeTotal = otherIncomes
                .map { $0.amount }
                .reduce(0, +)
            
            let rentPayments = rentPaymentsQuery
                .filter({ $0.meeting == meeting && $0.date >= startDate && $0.date <= endDate })
            let rentPaymentsTotal = rentPayments
                .map { $0.amount }
                .reduce(0, +)

            let got = collectionsTotal + otherIncomeTotal
            let spent = rentPaymentsTotal + groupConscienceTotal + otherExpensesTotal
            let endingBalance = startingBalance + got - spent - meeting.prudentReserve
            
            List {
                Section {
                    DatePicker("Start date", selection: $startDate)
                    DatePicker("End date", selection: $endDate)
                    
                    HStack {
                        Text("Starting Cash On Hand")
                            .bold()
                        Spacer()
                        Text(startingBalance.formatted(.currency(code: currencyCode)))
                            .monospaced()
                            .bold()
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
                        Text("Group Conscience")
                        Spacer()
                        Text((groupConscienceTotal * -1).formatted(.currency(code: currencyCode)))
                            .monospaced()
                    }
                    HStack {
                        Text("Ending Cash On Hand")
                            .bold()
                        Spacer()
                        Text((endingBalance + meeting.prudentReserve).formatted(.currency(code: currencyCode)))
                            .monospaced()
                            .bold()
                    }
                    HStack {
                        Text("Prudent Reserve")
                        Spacer()
                        Text((meeting.prudentReserve * -1).formatted(.currency(code: currencyCode)))
                            .monospaced()
                    }
                    HStack {
                        Text("Ending Balance")
                            .bold()
                        Spacer()
                        Text(endingBalance.formatted(.currency(code: currencyCode)))
                            .monospaced()
                            .bold()
                    }
                }
                
                Section("Collections") {
                    ForEach(collections) { collection in
                        HStack {
                            Text(collection.date.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            Text(collection.amount.formatted(.currency(code: currencyCode)))
                        }
                    }
                }
                
                Section("Other Income") {
                    ForEach(otherIncomes) { otherIncome in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(otherIncome.date.formatted(date: .abbreviated, time: .omitted))
                                Text(otherIncome.info)
                                    .font(.footnote)
                            }
                            Spacer()
                            Text(otherIncome.amount.formatted(.currency(code: currencyCode)))
                        }
                    }
                }
                
                Section("Rent Payments") {
                    ForEach(rentPayments) { rentPayment in
                        HStack {
                            Text(rentPayment.date.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            Text(rentPayment.amount.formatted(.currency(code: currencyCode)))
                        }
                    }
                }
                
                Section("Other Expenses") {
                    ForEach(otherExpenses) { otherExpense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(otherExpense.date.formatted(date: .abbreviated, time: .omitted))
                                Text(otherExpense.info)
                                    .font(.footnote)
                            }
                            Spacer()
                            Text(otherExpense.amount.formatted(.currency(code: currencyCode)))
                        }
                    }
                }
                
                Section("Group Conscience") {
                    ForEach(groupConsciencePayments) { payment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(payment.date.formatted(date: .abbreviated, time: .omitted))
                                Text(payment.type)
                                    .font(.footnote)
                            }
                            Spacer()
                            Text(payment.amount.formatted(.currency(code: currencyCode)))
                        }
                    }
                }
                
            }
            .formStyle(.grouped)
            .navigationTitle("Report")
        } else {
            ContentUnavailableView("No meeting selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        }
    }
}

extension Date {
    var startDateOfMonth: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }

    var endDateOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1, hour: 23, minute: 59), to: self.startDateOfMonth) else {
            fatalError("Unable to get end date from date")
        }
        return date
    }
}
