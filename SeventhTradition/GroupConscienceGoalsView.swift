//
//  GroupConscienceGoalsView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct GroupConscienceGoalsView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \GroupConscienceGoal.date, order: .reverse) private var groupConscienceGoals: [GroupConscienceGoal]
    
    @State private var selectedGroupConscienceGoal: GroupConscienceGoal?
    
    var body: some View {
        List(selection: $selectedGroupConscienceGoal) {
            ForEach(groupConscienceGoals.filter({ $0.meeting == meeting })) { goal in
                NavigationLink(destination: GroupConscienceGoalView(goal: goal)) {
                    HStack {
                        Text(goal.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text(goal.amount.formatted(.currency(code: "USD")))
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Group Conscience")
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
            let new = GroupConscienceGoal(amount: 0, date: Date(), info: "", method: "", who: "")
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
