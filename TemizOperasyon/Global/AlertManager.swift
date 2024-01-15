//
//  AlertManager.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 1.06.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    func showAlert(message: String, action: String? = "Ok") {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
}
