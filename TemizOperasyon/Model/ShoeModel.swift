//
//  ShoeModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 30.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import Foundation

class ShoeModel {
    
    let id: Int
    let barcode: String
    let rack: String
    var image: String
    let product_status: String
    
    
    
    init(id: Int, barcode: String, rack: String, image: String, product_status: String) {
        
        self.id = id
        self.barcode = barcode
        self.rack = rack
        self.image = image
        self.product_status = product_status
        
        
        
    }
    
}
