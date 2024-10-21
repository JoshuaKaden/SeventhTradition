//
//  GroupConscienceGoalView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct GroupConscienceGoalView: View {
    
    @State var goal: GroupConscienceGoal?
    
    @Environment(\.currencyCode) private var currencyCode
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditing: Bool = false
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var isPercent: Bool = false
    @State private var percentInt: Double = 0
    @State private var type: String = ""
    
    @State private var typeTemplate: GoalType = .none
    
    private enum GoalType {
        case
        local,
        area,
        intragroup,
        gsb,
        gsr,
        none
        
        var name: String {
            switch self {
            case .local:
                "Local District"
            case .area:
                "Area Committee"
            case.intragroup:
                "Local Intragroup or Central Office"
            case .gsb:
                "General Service Board"
            case .gsr:
                "GS Representative travel"
            case .none:
                "optionally, pick a template name"
            }
        }
    }
    
    private var hasChange: Bool {
        guard let goal else {
            return false
        }
        if amount != goal.amount ||
            date != goal.date ||
            isPercent != goal.isPercent ||
            percentInt != goal.percent * 100 ||
            type != goal.type
        {
            return true
        }
        return false
    }
    
    var body: some View {
        if goal == nil {
            ContentUnavailableView("No goal selected", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        } else if let goal {
            Form {
                if isEditing {
                    Section("Type") {
                        Picker("Template", selection: $typeTemplate) {
                            Text(GoalType.local.name).tag(GoalType.local)
                            Text(GoalType.area.name).tag(GoalType.area)
                            Text(GoalType.intragroup.name).tag(GoalType.intragroup)
                            Text(GoalType.gsb.name).tag(GoalType.gsb)
                            Text(GoalType.gsr.name).tag(GoalType.gsr)
                            Text(GoalType.none.name).tag(GoalType.none)
                        }
                        TextField("", text: $type)
                    }
                    Section("Is Percent") {
                        Toggle("", isOn: $isPercent)
                    }
                    if isPercent {
                        Section("Percent") {
                            TextField("", value: $percentInt, format: .number)
#if os(iOS)
                                .keyboardType(.decimalPad)
#endif
                        }
                    } else {
                        Section("Amount") {
                            TextField("", value: $amount, format: .number)
#if os(iOS)
                                .keyboardType(.decimalPad)
#endif
                        }
                    }
                    Section("Date") {
                        DatePicker("", selection: $date)
                    }
                } else {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Type")
                                .font(.footnote)
                            Text(goal.type)
                        }
                        if goal.isPercent {
                            VStack(alignment: .leading) {
                                Text(goal.percent.formatted(.percent))
                                Text("Of Treasury Balance")
                                    .font(.footnote)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                Text("Amount")
                                    .font(.footnote)
                                Text(goal.amount.formatted(.currency(code: currencyCode)))
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.footnote)
                            Text(goal.date.formatted())
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .task {
                assignFromModel()
            }
            .animation(nil, value: isEditing)
            .onChange(of: typeTemplate, { oldValue, newValue in
                type = newValue.name
            })
            .toolbar {
                if isEditing == true {
                    ToolbarItem {
                        Button(action: cancelEdits) {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem {
                        Button(action: save) {
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
        }
    }
    
    private func assignFromModel() {
        if let goal {
            amount = goal.amount
            date = goal.date
            isPercent = goal.isPercent
            percentInt = goal.percent * 100
            type = goal.type
        }
    }
    
    private func assignToModel() {
        if let goal {
            goal.amount = amount
            goal.date = date
            goal.isPercent = isPercent
            goal.percent = percentInt / 100
            goal.type = type
        }
    }
    
    private func cancelEdits() {
        withAnimation {
            assignFromModel()
            isEditing = false
        }
    }
    
    private func save() {
        withAnimation {
            assignToModel()
            isEditing = false
        }
        try? modelContext.save()
    }
    
    private func toggleIsEditing() {
        withAnimation {
            isEditing.toggle()
        }
    }
    
}
