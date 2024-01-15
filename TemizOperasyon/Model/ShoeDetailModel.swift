//
//  ShoeDetailModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import Foundation

class ShoeDetailModel {
    
    let id: Int
    let barcode: String
    let image: String
    var product_status: String
    let is_control: Int
    let rack: String
    
    
    
    init(id: Int, barcode: String, image: String, product_status: String, is_control: Int, rack: String) {
        
        self.id = id
        self.barcode = barcode
        self.image = image
        self.product_status = product_status
        self.is_control = is_control
        self.rack = rack
        
        
    }
    
}
