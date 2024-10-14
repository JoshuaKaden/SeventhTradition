//
//  MeetingView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import SwiftData
import SwiftUI

struct MeetingView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \RentPayment.date, order: .reverse) private var rentPayments: [RentPayment]

    @State private var isEditing: Bool = false
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var beginningBalance: Double = 0
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
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("Beginning Balance")
                                .font(.footnote)
                            Text(meeting.beginningBalance.formatted(.currency(code: "USD")))
                        }
                        VStack(alignment: .leading) {
                            Text("Cash on Hand")
                                .font(.footnote)
                            Text(meeting.cashOnHand.formatted(.currency(code: "USD")))
                        }
                        VStack(alignment: .leading) {
                            Text("Prudent Reserve")
                                .font(.footnote)
                            Text(meeting.prudentReserve.formatted(.currency(code: "USD")))
                        }
                        VStack(alignment: .leading) {
                            Text("Treasury Balance")
                                .font(.footnote)
                            Text(meeting.treasuryBalance.formatted(.currency(code: "USD")))
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("\(meeting.rentIntervalString) Rent")
                                .font(.footnote)
                            Text(meeting.rent.formatted(.currency(code: "USD")))
                        }
                        NavigationLink(destination: RentPaymentsView(meeting: $meeting)) {
                            VStack(alignment: .leading) {
                                Text("Rent Payments")
                                let rentPayments = rentPayments.filter({ $0.meeting == meeting })
                                if let rentPayment = rentPayments.first {
                                    HStack {
                                        Text("Most Recent")
                                            .font(.footnote)
                                        Text(rentPayment.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.footnote)
                                        Text(rentPayment.amount.formatted(.currency(code: "USD")))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("Meeting ID")
                                .font(.footnote)
                            Text(meeting.id.uuidString)
                                .font(.footnote)
                        }
                    }
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
        } else {
            ContentUnavailableView("No meeting selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        }
    }
    
    private func assignFromMeeting() {
        if let meeting {
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
        }
    }
    
    private func cancelEdits() {
        withAnimation {
            assignFromMeeting()
            isEditing = false
        }
    }
    
    private func saveMeeting() {
        withAnimation {
            assignToMeeting()
            isEditing = false
        }
    }
    
    private func toggleIsEditing() {
        withAnimation {
            isEditing.toggle()
        }
    }
}
