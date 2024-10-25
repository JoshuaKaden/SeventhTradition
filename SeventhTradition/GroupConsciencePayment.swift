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
    var type: String
    var who: String
    
    var meeting: Meeting?
    
    init(amount: Double, date: Date, method: String, type: String, who: String, meeting: Meeting? = nil) {
        self.amount = amount
        self.date = date
        self.method = method
        self.type = type
        self.who = who
        self.meeting = meeting
    }
}
