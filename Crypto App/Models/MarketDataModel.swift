//
//  MarketDataModel.swift
//  Crypto App
//
//  Created by Xcode on 09/08/22.
//

import Foundation

/*
 url - https://api.coingecko.com/api/v3/global

 */


struct GlobalData: Codable {
    let data: MarkketDataModel?
}

struct MarkketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { (key, value) -> Bool in
            return key == "usd"
        }){
            return "\(item.value)"
        }
        return ""
    }
    
    var volume: String{
        if let item = totalVolume.first(where: { $0.key == "usd"}){
            return "\(item.value)"
        }
        return ""
    }
    
    var btcDominance: String{
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }){
            return item.value.asPercentString()
        }
        return ""
    }
    
}

