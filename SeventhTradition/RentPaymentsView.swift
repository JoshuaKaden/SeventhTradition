//
//  RentPaymentsView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct RentPaymentsView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \RentPayment.date, order: .reverse) private var rentPayments: [RentPayment]
    
    @State private var selectedRentPayment: RentPayment?
    
    var body: some View {
        List(selection: $selectedRentPayment) {
            ForEach(rentPayments.filter({ $0.meeting == meeting })) { rentPayment in
                NavigationLink(destination: RentPaymentView(rentPayment: rentPayment)) {
                    HStack {
                        Text(rentPayment.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text(rentPayment.amount.formatted(.currency(code: "USD")))
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Rent Payments")
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
#endif
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let new = RentPayment(date: Date())
            new.amount = meeting?.rent ?? 0
            modelContext.insert(new)
            meeting?.rentPayments?.append(new)
            new.meeting = meeting
        }
        try? modelContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        let rentPayments = rentPayments.filter({ $0.meeting == meeting })
        withAnimation {
            for index in offsets {
                modelContext.delete(rentPayments[index])
            }
        }
        try? modelContext.save()
    }
}
