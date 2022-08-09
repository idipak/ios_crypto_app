//
//  UIApplication.swift
//  Crypto App
//
//  Created by Xcode on 08/08/22.
//

import Foundation
import UIKit

extension UIApplication{
    
    func endEditiong(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
