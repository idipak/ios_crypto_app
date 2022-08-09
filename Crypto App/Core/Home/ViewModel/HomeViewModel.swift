//
//  HomeViewModel.swift
//  Crypto App
//
//  Created by Xcode on 26/07/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var statistics: [StatisticModel] = [
     
    ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolio: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coindDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
       addSubscriber()
    }
    
    func addSubscriber(){
        
        $searchText
            .combineLatest(coindDataService.$altCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) //Execude code below only if no text typed for 0.5 seconds -- this is to make efficient processesing
            .map(filterCoin)
            .sink { [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellable)
        
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedData) in
                self?.statistics = returnedData
            }
            .store(in: &cancellable)
    }
    
    
    private func filterCoin(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        
        let lowerCaseText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCaseText) ||
            coin.symbol.lowercased().contains(lowerCaseText) ||
            coin.id.lowercased().contains(lowerCaseText)
        }
    }
    
    
    private func mapGlobalMarketData(marketDataModel: MarkketDataModel?) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentChange: 1)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
    
}
