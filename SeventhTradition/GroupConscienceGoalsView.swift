//
//  GroupConscienceGoalsView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct GroupConscienceGoalsView: View {
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.meeting) private var meeting
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \GroupConscienceGoal.type) private var groupConscienceGoals: [GroupConscienceGoal]
    
    @State private var selectedGroupConscienceGoal: GroupConscienceGoal?
    
    var body: some View {
        List(selection: $selectedGroupConscienceGoal) {
            ForEach(groupConscienceGoals.filter({ $0.meeting == meeting })) { goal in
                NavigationLink(destination: GroupConscienceGoalView(goal: goal)) {
                    HStack {
                        Text(goal.type)
                        Spacer()
                        if goal.isPercent {
                            Text(goal.percent.formatted(.percent))
                        } else {
                            Text(goal.amount.formatted(.currency(code: currencyCode)))
                        }
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("GC Goals")
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
            let new = GroupConscienceGoal(amount: 0, date: Date(), isPercent: true, percent: 0, type: "")
            new.type = "New Goal"
            modelContext.insert(new)
            meeting?.groupConscienceGoals?.append(new)
            new.meeting = meeting
        }
        try? modelContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        let groupConscienceGoals = groupConscienceGoals.filter({ $0.meeting == meeting })
        withAnimation {
            for index in offsets {
                modelContext.delete(groupConscienceGoals[index])
            }
        }
        try? modelContext.save()
    }
}
