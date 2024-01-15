//
//  DutyChatModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 14.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import Foundation

class DutyChatModel {
    
    let id: Int
    let name: String
    let message: String
    let image: String
    let date: String
    let is_me: Int
   
    
    
    
    init(id: Int, name: String, message: String, image: String, date: String, is_me: Int) {
        
        self.id = id
        self.name = name
        self.message = message
        self.image = image
        self.date = date
        self.is_me = is_me
        
        
    }
    
    
    
}
