//
//  Meeting.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import Foundation
import SwiftData

@Model
final class Meeting {
    var id: UUID
    var name: String
    var beginningBalance: Double
    var location: String
    var prudentReserve: Double
    var rent: Double
    var rentIsMonthly: Bool
    
    var rentIntervalString: String {
        if rentIsMonthly {
            return "Monthly"
        } else {
            return "Weekly"
        }
    }
    
    init(id: UUID = UUID(), name: String, beginningBalance: Double = 0, location: String = "", prudentReserve: Double = 0, rent: Double = 0, rentIsMonthly: Bool = true) {
        self.id = id
        self.name = name
        self.beginningBalance = beginningBalance
        self.location = location
        self.prudentReserve = prudentReserve
        self.rent = rent
        self.rentIsMonthly = rentIsMonthly
    }
}
