//
//  CoinDataService.swift
//  Crypto App
//
//  Created by Xcode on 27/07/22.
//

import Foundation
import Combine

class CoinDataService{
    
    @Published var altCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init(){
       getCoin()
    }
    
    func getCoin(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
    
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let convertedData = try decoder.decode([CoinModel].self, from: data)
                self.altCoins = convertedData
            
            } catch {
                print(error)
            }
            
            
            
        })
        task.resume()
         
        
        
        
        
//        coinSubscription = NetworkManager.download(url: url)
//            .decode(type: [CoinModel].self, decoder: JSONDecoder())
//            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoin) in
//                self?.altCoins = returnedCoin
//                self?.coinSubscription?.cancel()
//            })
           
            
        
        
        
    }
    
}
