//
//  LocalFileManager.swift
//  Crypto App
//
//  Created by Xcode on 08/08/22.
//

import Foundation
import UIKit

class LocalFileManager{
    
    static let instance = LocalFileManager()
    
    private init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        //create folder
        createFolderIfNeeded(folderName: folderName)
        
        //get image path
        guard let data = image.pngData(),
        let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else {return}
        
        //save image
        do{
            try data.write(to: url)
        } catch{
            print("Image error \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getUrlForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String){
        guard let url = getUrlForFolder(folderName: folderName) else {return}
        
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                print("Error creating directory \(error)")
            }
        }
    }
    
    private func getUrlForFolder(folderName: String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .localDomainMask).first
        else {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getUrlForImage(imageName: String, folderName: String) -> URL?{
        guard let folderURL = getUrlForFolder(folderName: folderName)
        else {return nil}
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
