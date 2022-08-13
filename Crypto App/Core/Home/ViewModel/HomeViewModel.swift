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
    @Published var isLoading: Bool = false
    
    private let coindDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
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
        
        //updates portfolio coin
        $allCoins
            .combineLatest(portfolioDataService.$savedEnties)
            .map(mapAllCoinToPortfolioCoin)
            .sink { [weak self] (returnedCoin) in
                self?.portfolio = returnedCoin
            }
            .store(in: &cancellable)
        
        
        marketDataService.$marketData
            .combineLatest($portfolio)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedData) in
                self?.statistics = returnedData
                self?.isLoading = false
            }
            .store(in: &cancellable)
        
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        self.isLoading = true
        coindDataService.getCoin()
        marketDataService.getData()
        HapticManager.notification(type: .success)
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
    
    private func mapAllCoinToPortfolioCoin(allCoin: [CoinModel], portfolioEntity: [PortfolioEntity]) -> [CoinModel]{
        allCoin
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntity.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHolding(amount: entity.amount)
            }
    }
    
    
    private func mapGlobalMarketData(marketDataModel: MarkketDataModel?, portfolioCoin: [CoinModel]) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoin.map({$0.currentHoldingPrice})
            .reduce(0, +) //This add all the value
        
        let previousValue = portfolioCoin.map { coin -> Double in
            let currentValue = coin.currentHoldingPrice
            let percentChange = coin.priceChangePercentage24H
            let previousValue = currentValue / (1 + (percentChange ?? 0))
            return previousValue
        }
            .reduce(0, +)
        
        let percentChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimal(), percentChange: percentChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
    
}
