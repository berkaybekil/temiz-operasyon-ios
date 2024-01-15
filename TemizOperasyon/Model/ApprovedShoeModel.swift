//
//  ApprovedShoeModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 5.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import Foundation

class ApprovedShoeModel {
    
    let id: Int
    let barcode: String
    let rack: String
    var image: String
    let product_status: String
    let repairType: String
    
    
    
    init(id: Int, barcode: String, rack: String, image: String, product_status: String, repairType: String) {
        
        self.id = id
        self.barcode = barcode
        self.rack = rack
        self.image = image
        self.product_status = product_status
        self.repairType = repairType
        
        
    }
    
}
