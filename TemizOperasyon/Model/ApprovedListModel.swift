//
//  ApprovedListModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 1.02.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import Foundation

class ApprovedListModel {
    
    let product_images_id: Int
    let user: String
    let barkod: String
    let rack: String
    let small_image: String
    let image: String
    let product_status: statusItem
    
    
    init(product_images_id: Int, user: String, barkod: String, rack: String, small_image: String, image: String, product_status: statusItem) {
        
        self.product_images_id = product_images_id
        self.user = user
        self.barkod = barkod
        self.rack = rack
        self.small_image = small_image
        self.image = image
        self.product_status = product_status
        
        
    }
    
}
