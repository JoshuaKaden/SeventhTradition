//
//  OtherExpensesView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct OtherExpensesView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \OtherExpense.date, order: .reverse) private var otherExpenses: [OtherExpense]
    
    @State private var selectedOtherExpense: OtherExpense?
    
    var body: some View {
        List(selection: $selectedOtherExpense) {
            ForEach(otherExpenses.filter({ $0.meeting == meeting })) { otherExpense in
                NavigationLink(destination: OtherExpenseView(otherExpense: otherExpense)) {
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
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Other Expenses")
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
            let new = OtherExpense(amount: 0, date: Date(), info: "")
            modelContext.insert(new)
            meeting?.otherExpenses?.append(new)
            new.meeting = meeting
        }
        try? modelContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        let otherExpenses = otherExpenses.filter({ $0.meeting == meeting })
        withAnimation {
            for index in offsets {
                modelContext.delete(otherExpenses[index])
            }
        }
        try? modelContext.save()
    }
}
