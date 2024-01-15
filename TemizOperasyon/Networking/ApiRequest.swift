//
//  ApiRequest.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApiRequest<ResponseType: Codable> {

    func webserviceUrl() -> String {
        #if DEBUG
        return "http://service.temiz.co/"
        #else
        return "http://service.temiz.co/"
        #endif
    }

    func apiPath() -> String {
        return "operation/"
    }

    func apiVersion() -> String {
        return "v1/"
    }

    func apiResource() -> String {
        return ""
    }

    func endPoint() -> String {
        return ""
    }

    func bodyParams() -> NSDictionary? {
        return [:]
    }

    func requestType() -> HTTPMethod {
        return .post
    }

    func contentType() -> String {
        return "application/json"
    }
}
