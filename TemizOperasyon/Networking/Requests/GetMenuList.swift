//
//  GetMenuList.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import Foundation

import Foundation

class GetMenuList: ApiRequest<[MainButtonModel]> {

    var token = DataManager.userToken

    override func apiResource() -> String {
        return "menu/"
    }

    override func endPoint() -> String {
        return "list"
    }

    override func bodyParams() -> NSDictionary? {
        return ["token": token]
    }

    override func requestType() -> HTTPMethod {
        return .post
    }

}
