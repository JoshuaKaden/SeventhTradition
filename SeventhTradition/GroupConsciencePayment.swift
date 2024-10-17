//
//  GroupConsciencePayment.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import Foundation
import SwiftData

@Model
final class GroupConsciencePayment {
    var amount: Double
    var date: Date
    var method: String
    var who: String
    
    var goal: GroupConscienceGoal?
    var meeting: Meeting?
    
    init(amount: Double, date: Date, method: String, who: String, goal: GroupConscienceGoal? = nil) {
        self.amount = amount
        self.date = date
        self.method = method
        self.who = who
        self.goal = goal
    }
}
