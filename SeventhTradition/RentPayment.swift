//
//  RentPayment.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import Foundation
import SwiftData

@Model
final class RentPayment {
    var amount: Double
    var date: Date
    var method: String
    var who: String
    
    var meeting: Meeting?
    
    init(amount: Double = 0, date: Date, method: String = "", who: String = "", meeting: Meeting? = nil) {
        self.amount = amount
        self.date = date
        self.method = method
        self.who = who
        self.meeting = meeting
    }
}
