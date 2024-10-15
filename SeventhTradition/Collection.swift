//
//  Collection.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import Foundation
import SwiftData

@Model
final class Collection {
    var amount: Double
    var date: Date
    
    var meeting: Meeting?
    
    init(amount: Double = 0, date: Date, meeting: Meeting? = nil) {
        self.amount = amount
        self.date = date
        self.meeting = meeting
    }
}
