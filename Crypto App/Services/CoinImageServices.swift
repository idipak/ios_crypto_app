//
//  CoinImageServices.swift
//  Crypto App
//
//  Created by Xcode on 30/07/22.
//

import Foundation
import SwiftUI
import Combine


class CoinImageService{
    
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_image"
    private let imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
            print("Image retrieved from folder")
        } else {
            downloadCoinImage()
            print("Download image")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else {return}
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
