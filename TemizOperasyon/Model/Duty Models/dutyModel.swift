//
//  dutyModel.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 10.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import Foundation

class dutyModel {
    
    let id: Int
    let order_id: Int
    let admin_user_name: String
    let from_admin_user_name: String
    let task_groups_name: String
    let subject: String
    let message: String
    let user_name: String
    let image_1: String
    let image_2: String
    let image_3: String
    let image_4: String
    var is_complete: Int
    let barcode_id: Int
    let barcode_number: String
    let barcode_image: String
    let is_read: Int
    let read_admin_user_name: String
    let due_date: String
    
    
    init(id: Int, order_id: Int, admin_user_name: String, from_admin_user_name: String, task_groups_name: String, subject: String, message: String, user_name: String, image_1: String, image_2: String, image_3: String, image_4: String, is_complete: Int, barcode_id: Int, barcode_number: String, barcode_image: String, is_read: Int, read_admin_user_name: String, due_date: String) {
        
        self.id = id
        self.order_id = order_id
        self.admin_user_name = admin_user_name
        self.from_admin_user_name = from_admin_user_name
        self.task_groups_name = task_groups_name
        self.subject = subject
        self.message = message
        self.user_name = user_name
        self.image_1 = image_1
        self.image_2 = image_2
        self.image_3 = image_3
        self.image_4 = image_4
        self.is_complete = is_complete
        self.barcode_id = barcode_id
        self.barcode_number = barcode_number
        self.barcode_image = barcode_image
        self.is_read = is_read
        self.read_admin_user_name = read_admin_user_name
        self.due_date = due_date
        
    }
    
    
    
}
