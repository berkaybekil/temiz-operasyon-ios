//
//  ApiResponse.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import Foundation

class ApiResponse {
    var success: Bool!   // whether the API call passed or failed
    var message: String? // message returned from the API
    var errorCode: String?
    var data: AnyObject? // actual data returned from the API
    init(success: Bool, message: String? = nil, errorCode: String? = "00", data: AnyObject? = nil) {
        self.success = success
        self.message = message
        self.errorCode = errorCode
        self.data = data
    }
}
