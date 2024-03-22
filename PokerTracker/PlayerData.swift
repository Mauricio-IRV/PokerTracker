//
//  DataItem.swift
//  PokerTracker
//
//  Created by Reece on 3/18/24.
//

import Foundation
import SwiftData

@Model
class PlayerData: Identifiable, Hashable {
    var name: String = ""
    var balance: String = ""
    var id: String
    
    var amountHistory: [String] = []
    var amountsDeleted: [String] = []
    
    var dateHistory: [String] = []
    var datesDeleted: [String] = []
    
    init(name: String?, balance: String?) {
        self.id = UUID().uuidString
        
        if let unwrappedName = name {
            if unwrappedName.isEmpty {
                self.name = "Player"
            } else {
                self.name = unwrappedName
            }
        }
        
        if let unwrappedBalance = balance {
            let balanceVal: Double = (unwrappedBalance as NSString).doubleValue
            let formattedBalance = String(format: "%.2f", balanceVal)
            let formattedDate = getFormattedDate()
            
            self.balance = "0.00"
            storeHistory(amount: "+0.00", date: formattedDate, deleted: false)
            
            if balanceVal > 0 {
                self.balance = formattedBalance
                storeHistory(amount: "+" + formattedBalance, date: formattedDate, deleted: false)
                
            } else if balanceVal < 0 {
                self.balance = formattedBalance
                storeHistory(amount: "-" + formattedBalance, date: formattedDate, deleted: false)
            }
        }
    }
    
    func updateBalance(amount: String, increment: Bool, date: String?) {
        let newBalance: Double
        
        let prevBalance: Double = (balance as NSString).doubleValue
        let amount: Double = (amount as NSString).doubleValue
        let formattedDate: String
        
        if amount == 0 { return }
        
        if let unwrappedDate = date { formattedDate = unwrappedDate
        } else { formattedDate = getFormattedDate() }
        
        if increment {
            newBalance = prevBalance + amount
            storeHistory(amount: "+" + String(format: "%.2f", amount), date: formattedDate, deleted: false)
        }
        else {
            newBalance = prevBalance - amount
            storeHistory(amount: "-" + String(format: "%.2f", amount), date: formattedDate, deleted: false)
        }
        
        balance.self = String(format: "%.2f", newBalance)
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy -- hh:mm a"
        
        return dateFormatter.string(from: Date())
    }
    
    func undoTransaction() {
        let amount = self.amountHistory.popLast()
        let date = self.dateHistory.popLast()
        
        if let unwrappedAmount = amount {
            if let unwrappedDate = date { storeHistory(amount: unwrappedAmount, date: unwrappedDate, deleted: true) }
            
            let amountVal: Double = (unwrappedAmount as NSString).doubleValue
            let amountAbs = abs(amountVal)
            
            let formattedAmount = String(format: "%.2f", amountAbs)
            
            if amountVal >= 0 { updateBalance(amount: formattedAmount, increment: false, date: nil) }
            else { updateBalance(amount: formattedAmount, increment: true, date: nil) }
        }
        
        self.dateHistory.removeLast()
        self.amountHistory.removeLast()
    }
    
    func redoTransaction() {
        let amount = self.amountsDeleted.popLast()
        let date = self.datesDeleted.popLast()
        
        if let unwrappedAmount = amount {
            if let unwrappedDate = date {
                let amountVal: Double = (unwrappedAmount as NSString).doubleValue
                let amountAbs = abs(amountVal)
                
                let formattedAmount = String(format: "%.2f", amountAbs)
                
                if amountVal >= 0 { updateBalance(amount: formattedAmount, increment: true, date: unwrappedDate) }
                else { updateBalance(amount: formattedAmount, increment: false, date: unwrappedDate) }
            }
        }
    }
    
    func storeHistory(amount: String, date: String, deleted: Bool) {
        if (deleted) {
            self.amountsDeleted.append(amount)
            self.datesDeleted.append(date)
        } else {
            self.amountHistory.append(amount)
            self.dateHistory.append(date)
        }
    }
    
    func clearCache() {
        self.amountsDeleted = []
        self.datesDeleted = []
    }
    
    func getBalance() -> Double {
        return (balance as NSString).doubleValue
    }
}
