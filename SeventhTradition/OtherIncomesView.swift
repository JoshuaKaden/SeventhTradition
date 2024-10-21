//
//  OtherIncomesView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct OtherIncomesView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \OtherIncome.date, order: .reverse) private var otherIncomes: [OtherIncome]
    
    @State private var selectedOtherIncome: OtherIncome?
    
    var body: some View {
        List(selection: $selectedOtherIncome) {
            ForEach(otherIncomes.filter({ $0.meeting == meeting })) { otherIncome in
                NavigationLink(destination: OtherIncomeView(otherIncome: otherIncome)) {
                    HStack {
                        Text(otherIncome.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text(otherIncome.amount.formatted(.currency(code: currencyCode)))
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Other Income")
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
            let new = OtherIncome(amount: 0, date: Date(), info: "")
            modelContext.insert(new)
            meeting?.otherIncome?.append(new)
            new.meeting = meeting
        }
        try? modelContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        let otherIncomes = otherIncomes.filter({ $0.meeting == meeting })
        withAnimation {
            for index in offsets {
                modelContext.delete(otherIncomes[index])
            }
        }
        try? modelContext.save()
    }
}
