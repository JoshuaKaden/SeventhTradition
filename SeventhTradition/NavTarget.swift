//
//  NavTarget.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/24/24.
//

enum NavTarget: Int, Identifiable, RawRepresentable {
    
    var id: Int { rawValue }
    
    case
    collections,
    otherExpenses,
    otherIncome,
    gcAutoCreate,
    gcGoals,
    gcPayments,
    rentPayments,
    report
}
