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
    var info: String
    var method: String
    var who: String
    
    var goal: GroupConscienceGoal?
    
    init(amount: Double, date: Date, info: String, method: String, who: String, goal: GroupConscienceGoal? = nil) {
        self.amount = amount
        self.date = date
        self.info = info
        self.method = method
        self.who = who
        self.goal = goal
    }
}
