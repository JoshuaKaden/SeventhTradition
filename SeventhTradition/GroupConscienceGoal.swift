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
    var percent: Double
    var type: String
    
    var meeting: Meeting?
    @Relationship(inverse: \GroupConsciencePayment.goal) var payments: [GroupConsciencePayment]? = []
    
    init(amount: Double, date: Date, percent: Double, type: String, meeting: Meeting? = nil, payments: [GroupConsciencePayment]? = nil) {
        self.amount = amount
        self.date = date
        self.percent = percent
        self.type = type
        self.meeting = meeting
        self.payments = payments
    }
}
