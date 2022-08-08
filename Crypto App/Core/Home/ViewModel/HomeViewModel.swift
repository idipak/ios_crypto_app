//
//  HomeViewModel.swift
//  Crypto App
//
//  Created by Xcode on 26/07/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolio: [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
       addSubscriber()
    }
    
    func addSubscriber(){
        dataService.$altCoins
            .sink { [weak self] (returnedValue) in
    
                self?.allCoins = returnedValue
            }
            .store(in: &cancellable)
    }
}
