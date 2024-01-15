//
//  UserManager.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 1.06.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import Foundation
import UIKit

class UserManager {
    
    static let shared = UserManager()
    
    func logout() {
        
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "userToken")
        defaults.set(nil, forKey: "userID")
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryBoard.instantiateViewController(withIdentifier: "login")
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = loginVC
        
    }
    
}
