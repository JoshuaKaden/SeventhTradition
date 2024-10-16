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
    var info: String
    var method: String
    var who: String
    
    var meeting: Meeting?
    @Relationship(inverse: \GroupConsciencePayment.goal) var payments: [GroupConsciencePayment]? = []
    
    init(amount: Double, date: Date, info: String, method: String, who: String, meeting: Meeting? = nil, payments: [GroupConsciencePayment]? = nil) {
        self.amount = amount
        self.date = date
        self.info = info
        self.method = method
        self.who = who
        self.meeting = meeting
        self.payments = payments
    }
}
