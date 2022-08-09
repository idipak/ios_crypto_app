//
//  StatisticModel.swift
//  Crypto App
//
//  Created by Xcode on 09/08/22.
//

import Foundation

struct StatisticModel: Identifiable{
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentChange: Double?
    
    init(title: String, value: String, percentChange: Double? = nil){
        self.title = title
        self.value = value
        self.percentChange = percentChange
    }
}


