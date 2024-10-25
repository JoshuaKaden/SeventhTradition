//
//  GroupConscienceGoal.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import Foundation
import SwiftData

@Model
final class GroupConscienceGoal {
    var amount: Double
    var date: Date
    var isPercent: Bool
    var percent: Double
    var type: String
    
    var meeting: Meeting?
    
    init(amount: Double, date: Date, isPercent: Bool, percent: Double, type: String, meeting: Meeting? = nil) {
        self.amount = amount
        self.date = date
        self.isPercent = isPercent
        self.percent = percent
        self.type = type
        self.meeting = meeting
    }
}
