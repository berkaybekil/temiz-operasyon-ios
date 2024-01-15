//
//  ECommerceListModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 13.06.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import Foundation

class ECommerceListModel {
    
    let id: Int
    let price_id: Int
    let price_name: String
    let user_name: String
    let order_id: Int
    let image: String
    let product_status: String
    
    
    
    init(id: Int, price_id: Int, price_name: String, user_name: String, order_id: Int, image: String, product_status: String) {
        
        self.id = id
        self.price_id = price_id
        self.price_name = price_name
        self.user_name = user_name
        self.order_id = order_id
        self.image = image
        self.product_status = product_status
        
        
    }
    
}
