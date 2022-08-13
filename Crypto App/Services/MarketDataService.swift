//
//  MarketDataService.swift
//  Crypto App
//
//  Created by Xcode on 09/08/22.
//

import Foundation
import Combine

class MarketDataService{
    
    @Published var marketData: MarkketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init(){
       getData()
    }
    
    func getData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
    
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let convertedData = try decoder.decode(GlobalData.self, from: data)
                self.marketData = convertedData.data
            
            } catch {
                print(error)
            }
            
            
            
        })
        task.resume()
         
        
        
    }
    
}
