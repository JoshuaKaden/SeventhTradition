//
//  MeetingView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import SwiftData
import SwiftUI

struct MeetingView: View {
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.dismiss) private var dismiss
    @Environment(\.meeting) private var meeting
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Collection.date, order: .reverse) private var collections: [Collection]
    @Query(sort: \GroupConsciencePayment.date, order: .reverse) private var groupConsciencePayments: [GroupConsciencePayment]
    @Query(sort: \OtherIncome.date, order: .reverse) private var otherIncomes: [OtherIncome]
    @Query(sort: \RentPayment.date, order: .reverse) private var rentPayments: [RentPayment]

    @State private var isEditing: Bool = false
    @State private var isPresentingConfirm = false
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var beginningBalance: Double = 0
    @State private var cashOnHand: Double = 0
    @State private var prudentReserve: Double = 0
    @State private var rent: Double = 0
    @State private var rentIsMonthly: Bool = false
    
    private var hasChange: Bool {
        guard let meeting else {
            return false
        }
        
        if name != meeting.name ||
            location != meeting.location ||
            beginningBalance != meeting.beginningBalance ||
            prudentReserve != meeting.prudentReserve ||
            rent != meeting.rent ||
            rentIsMonthly != meeting.rentIsMonthly
        {
            return true
        }
        return false
    }
    
    var body: some View {
        if let meeting {
            Form {
                if isEditing == true {
                    
                    Section("Name") {
                        TextField(text: $name, label: {})
                    }
                    
                    Section("Location") {
                        TextField(text: $location, label: {})
                    }
                                        
                    Section("Rent") {
                        TextField("", value: $rent, format: .number)
#if os(iOS)
                            .keyboardType(.decimalPad)
#endif
                        Picker("Frequency", selection: $rentIsMonthly) {
                            Text("Monthly").tag(true)
                            Text("Weekly").tag(false)
                        }
                    }
                    
                    Section("Beginning Balance") {
                        TextField("", value: $beginningBalance, format: .number)
#if os(iOS)
                            .keyboardType(.decimalPad)
#endif
                    }
                    
                    Section("Prudent Reserve") {
                        TextField("", value: $prudentReserve, format: .number)
#if os(iOS)
                            .keyboardType(.decimalPad)
#endif
                    }
                    
                    Section {
                        Button("Delete", role: .destructive) {
                            isPresentingConfirm = true
                        }
                        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                            Button("Delete this meeting?", role: .destructive) {
                                deleteMeeting()
                            }
                        } message: {
                            Text("This meeting, and all its associated data (payments, etc.) will be deleted")
                        }
                        .buttonStyle(.borderless)
                        .padding()
                        .frame(maxWidth: .infinity)
                    }

                } else {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.footnote)
                            Text(meeting.name)
                        }
                        if !meeting.location.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Location")
                                    .font(.footnote)
                                Text(meeting.location)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Beginning Balance")
                                .font(.footnote)
                            Text(meeting.beginningBalance.formatted(.currency(code: currencyCode)))
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("Cash on Hand")
                                .font(.footnote)
                            Text(cashOnHand.formatted(.currency(code: currencyCode)))
                        }
                        VStack(alignment: .leading) {
                            Text("Prudent Reserve")
                                .font(.footnote)
                            Text(meeting.prudentReserve.formatted(.currency(code: currencyCode)))
                        }
                        VStack(alignment: .leading) {
                            Text("Treasury Balance")
                                .font(.footnote)
                            let balance = cashOnHand - meeting.prudentReserve
                            Text(balance.formatted(.currency(code: currencyCode)))
                            Text("as of \(meeting.cashOnHandAsOf.formatted(date: .abbreviated, time: .standard))")
                                .font(.footnote)
                                .italic()
                        }
                        NavigationLink(value: NavTarget.report) {
                            Text("Treasurer's Report")
                        }
                    }
                    
                    Section {
                        NavigationLink(value: NavTarget.collections) {
                            VStack(alignment: .leading) {
                                Text("Collections")
                                let collections = collections.filter({ $0.meeting == meeting })
                                if let collection = collections.first {
                                    HStack {
                                        Text("Most Recent")
                                            .font(.footnote)
                                        Text(collection.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.footnote)
                                        Text(collection.amount.formatted(.currency(code: currencyCode)))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        NavigationLink(value: NavTarget.otherIncome) {
                            Text("Other Income")
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("\(meeting.rentIntervalString) Rent")
                                .font(.footnote)
                            Text(meeting.rent.formatted(.currency(code: currencyCode)))
                        }
                        NavigationLink(value: NavTarget.rentPayments) {
                            VStack(alignment: .leading) {
                                Text("Rent Payments")
                                let rentPayments = rentPayments.filter({ $0.meeting == meeting })
                                if let rentPayment = rentPayments.first {
                                    HStack {
                                        Text("Most Recent")
                                            .font(.footnote)
                                        Text(rentPayment.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.footnote)
                                        Text(rentPayment.amount.formatted(.currency(code: currencyCode)))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        NavigationLink(value: NavTarget.otherExpenses) {
                            Text("Other Expenses")
                        }
                    }
                                        
                    Section("Group Conscience") {
                        NavigationLink(value: NavTarget.gcPayments) {
                            VStack(alignment: .leading) {
                                Text("Payments")
                                let payments = groupConsciencePayments.filter({ $0.meeting == meeting })
                                if let payment = payments.first {
                                    HStack {
                                        Text("Most Recent")
                                            .font(.footnote)
                                        Text(payment.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.footnote)
                                        Text(payment.amount.formatted(.currency(code: currencyCode)))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        NavigationLink(value: NavTarget.gcGoals) {
                            Text("Goals")
                        }
                        NavigationLink(value: NavTarget.gcAutoCreate) {
                            VStack(alignment: .leading) {
                                Text("Auto-create payments")
                                Text("Use this to generate a payment for each goal")
                                    .font(.footnote)
                                    .italic()
                            }
                        }
                    }
                    
//                    Section {
//                        VStack(alignment: .leading) {
//                            Text("Meeting ID")
//                                .font(.footnote)
//                            Text(meeting.id.uuidString)
//                                .font(.footnote)
//                        }
//                    }
                }
            }
            .formStyle(.grouped)
            .task {
                assignFromMeeting()
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
                        Button(action: saveMeeting) {
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
            .navigationDestination(for: NavTarget.self) { navTarget in
                switch navTarget {
                case .collections:
                    CollectionsView()
                case .gcAutoCreate:
                    GeneratePaymentsView()
                case .gcGoals:
                    GroupConscienceGoalsView()
                case .gcPayments:
                    GroupConsciencePaymentsView()
                case .otherExpenses:
                    OtherExpensesView()
                case .otherIncome:
                    OtherIncomesView()
                case .rentPayments:
                    RentPaymentsView()
                case .report:
                    Report()
                }
            }
        } else {
            ContentUnavailableView("No meeting selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        }
    }
    
    private func assignFromMeeting() {
        if let meeting {
            updateSummaries()
            
            name = meeting.name
            location = meeting.location
            beginningBalance = meeting.beginningBalance
            prudentReserve = meeting.prudentReserve
            rent = meeting.rent
            rentIsMonthly = meeting.rentIsMonthly
        }
    }
    
    private func assignToMeeting() {
        if let meeting {
            meeting.name = name
            meeting.location = location
            meeting.beginningBalance = beginningBalance
            meeting.prudentReserve = prudentReserve
            meeting.rent = rent
            meeting.rentIsMonthly = rentIsMonthly
            
            updateSummaries()
        }
    }
    
    private func cancelEdits() {
        withAnimation {
            assignFromMeeting()
            isEditing = false
        }
    }
    
    private func deleteMeeting() {
        guard let meeting else {
            dismiss()
            return
        }
        
        for item in meeting.collections ?? [] {
            modelContext.delete(item)
        }

        for item in meeting.groupConscienceGoals ?? [] {
            modelContext.delete(item)
        }

        for item in meeting.groupConsciencePayments ?? [] {
            modelContext.delete(item)
        }

        for item in meeting.otherIncome ?? [] {
            modelContext.delete(item)
        }

        for item in meeting.rentPayments ?? [] {
            modelContext.delete(item)
        }

        modelContext.delete(meeting)
        
        try? modelContext.save()
        dismiss()
    }
    
    private func saveMeeting() {
        withAnimation {
            assignToMeeting()
            isEditing = false
        }
        try? modelContext.save()
    }
    
    private func toggleIsEditing() {
        withAnimation {
            isEditing.toggle()
        }
    }
    
    private func updateSummaries() {
        meeting?.updateSummaries(
            collections: collections.filter({ $0.meeting == meeting }),
            groupConsciencePayments: groupConsciencePayments.filter({ $0.meeting == meeting }),
            otherIncomes: otherIncomes.filter({ $0.meeting == meeting }),
            rentPayments: rentPayments.filter({ $0.meeting == meeting })
        )
        
        try? modelContext.save()
        
        cashOnHand = meeting?.cashOnHand ?? 0
    }
}
