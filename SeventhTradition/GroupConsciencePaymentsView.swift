//
//  GroupConsciencePaymentsView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct GroupConsciencePaymentsView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \GroupConsciencePayment.date, order: .reverse) private var groupConsciencePayments: [GroupConsciencePayment]
    
    @State private var selectedGroupConsciencePayment: GroupConsciencePayment?
    
    var body: some View {
        List(selection: $selectedGroupConsciencePayment) {
            ForEach(groupConsciencePayments.filter({ $0.meeting == meeting })) { payment in
                NavigationLink(destination: GroupConsciencePaymentView(payment: payment)) {
                    HStack {
                        Text(payment.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text(payment.amount.formatted(.currency(code: currencyCode)))
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("GC Payments")
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
            let new = GroupConsciencePayment(amount: 0, date: Date(), method: "", type: "", who: "")
            modelContext.insert(new)
            meeting?.groupConsciencePayments?.append(new)
            new.meeting = meeting
        }
        try? modelContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        let payments = groupConsciencePayments.filter({ $0.meeting == meeting })
        withAnimation {
            for index in offsets {
                modelContext.delete(payments[index])
            }
        }
        try? modelContext.save()
    }
}
