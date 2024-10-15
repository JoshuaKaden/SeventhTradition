//
//  OtherIncome.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import Foundation
import SwiftData

@Model
final class OtherIncome {
    var amount: Double
    var date: Date
    var info: String
    
    var meeting: Meeting?
    
    init(amount: Double, date: Date, info: String, meeting: Meeting? = nil) {
        self.amount = amount
        self.date = date
        self.info = info
        self.meeting = meeting
    }
}
