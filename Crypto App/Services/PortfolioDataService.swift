//
//  PortfolioDataService.swift
//  Crypto App
//
//  Created by Xcode on 11/08/22.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container: NSPersistentContainer
    private let containerName = "PorfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEnties: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading data \(error)")
            }
            self.getPortfolio()
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        if let entity = savedEnties.first(where: {$0.id == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do{
            savedEnties = try container.viewContext.fetch(request)
        } catch{
            print("Error fetching portfolio \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to core data. \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
    
}
