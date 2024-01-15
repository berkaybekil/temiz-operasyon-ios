//
//  CustomerModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import Foundation

class CustomerModel {
    
    let id: Int
    let name: String
    let pickup_date: String
    let delivery_date: String
    let is_cargo: Int
    let status: String
    
    
    init(id: Int, name: String, pickup_date: String, delivery_date: String, is_cargo: Int, status: String) {
        
        self.id = id
        self.name = name
        self.pickup_date = pickup_date
        self.delivery_date = delivery_date
        self.is_cargo = is_cargo
        self.status = status
        
        
    }
    
}
