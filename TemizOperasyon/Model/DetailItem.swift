//
//  DetailItem.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import Foundation

class detailItem {
    
    var admin_name = ""
    var message = ""
    var created_at = ""
    
    
    init(admin_name: String, message: String, created_at: String) {
        
        self.admin_name = admin_name
        self.message = message
        self.created_at = created_at
        
    }
    
    
    
}
