//
//  CoinImageViewModel.swift
//  Crypto App
//
//  Created by Xcode on 30/07/22.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    
    private let coin: CoinModel
    
    private let dataService: CoinImageService
    
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscriber()
        self.isLoading = true
    }
    
    private func addSubscriber(){
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellable)

    }
}
