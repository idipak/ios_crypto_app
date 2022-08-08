//
//  Double.swift
//  Crypto App
//
//  Created by Xcode on 26/07/22.
//

import Foundation


extension Double{
    
    private var currencyFormatter2: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimal() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    
    private var currencyFormatter6: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrencyWithDecimal() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    func asNumberString() -> String{
        return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String{
        return asNumberString() + "%"
    }
    
    
}
