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
    var cashOnHand: Double
    var location: String
    var prudentReserve: Double
    var rent: Double
    var rentIsMonthly: Bool
    
    @Relationship(inverse: \Collection.meeting)             var collections:             [Collection]? = []
    @Relationship(inverse: \GroupConscienceGoal.meeting)    var groupConscienceGoals:    [GroupConscienceGoal]? = []
    @Relationship(inverse: \GroupConsciencePayment.meeting) var groupConsciencePayments: [GroupConsciencePayment]? = []
    @Relationship(inverse: \OtherIncome.meeting)            var otherIncome:             [OtherIncome]? = []
    @Relationship(inverse: \RentPayment.meeting)            var rentPayments:            [RentPayment]? = []
    
    var rentIntervalString: String {
        if rentIsMonthly {
            return "Monthly"
        } else {
            return "Weekly"
        }
    }
    
    var treasuryBalance: Double {
        cashOnHand - prudentReserve
    }
    
    init(id: UUID, name: String, beginningBalance: Double = 0, cashOnHand: Double = 0, location: String = "", prudentReserve: Double = 0, rent: Double = 0, rentIsMonthly: Bool = false, collections: [Collection]? = nil, groupConscienceGoals: [GroupConscienceGoal]? = nil, groupConsciencePayments: [GroupConsciencePayment]? = nil, otherIncome: [OtherIncome]? = nil, rentPayments: [RentPayment]? = nil) {
        self.id = id
        self.name = name
        self.beginningBalance = beginningBalance
        self.cashOnHand = cashOnHand
        self.location = location
        self.prudentReserve = prudentReserve
        self.rent = rent
        self.rentIsMonthly = rentIsMonthly
        self.collections = collections
        self.groupConscienceGoals = groupConscienceGoals
        self.groupConsciencePayments = groupConsciencePayments
        self.otherIncome = otherIncome
        self.rentPayments = rentPayments
    }
    
    func updateSummaries(collections collectionsParam: [Collection] = [], groupConsciencePayments groupConsciencePaymentsParam: [GroupConsciencePayment] = [], otherIncomes otherIncomesParam: [OtherIncome] = [], rentPayments rentPaymentsParam: [RentPayment] = []) {
        
        let collections: [Collection]
        if collectionsParam.isEmpty {
            collections = self.collections ?? []
        } else {
            collections = collectionsParam
        }
        
        let groupConsciencePayments: [GroupConsciencePayment]
        if groupConsciencePaymentsParam.isEmpty {
            groupConsciencePayments = self.groupConsciencePayments ?? []
        } else {
            groupConsciencePayments = groupConsciencePaymentsParam
        }
        
        let otherIncomes: [OtherIncome]
        if otherIncomesParam.isEmpty {
            otherIncomes = self.otherIncome ?? []
        } else {
            otherIncomes = otherIncomesParam
        }
        
        let rentPayments: [RentPayment]
        if rentPaymentsParam.isEmpty {
            rentPayments = self.rentPayments ?? []
        } else {
            rentPayments = rentPaymentsParam
        }
        
        let collectionsTotal = collections
            .filter({ $0.meeting == self })
            .map { $0.amount }
            .reduce(0, +)
        
        let groupConscienceTotal = groupConsciencePayments
            .filter({ $0.meeting == self })
            .map { $0.amount }
            .reduce(0, +)
        
        let otherIncomeTotal = otherIncomes
            .filter({ $0.meeting == self })
            .map { $0.amount }
            .reduce(0, +)

        let rentPaymentsTotal = rentPayments
            .filter({ $0.meeting == self })
            .map { $0.amount }
            .reduce(0, +)
        
        let got = collectionsTotal + otherIncomeTotal
        let spent = rentPaymentsTotal + groupConscienceTotal
        
        cashOnHand = beginningBalance + got - spent
    }
}
