//
//  HttpMethod.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
