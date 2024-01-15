//
//  MenuService.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import Foundation

typealias CompletionHandler =  (Bool, AnyObject?, String) -> Void

class MenuService {

    func fetchMenuList(completion: @escaping CompletionHandler) {
        let request = GetMenuList()
        NetworkApiClient().callApi(request: request) { (apiResponse) in
            if apiResponse.success {
                completion(true, apiResponse.data, apiResponse.errorCode!)
            } else {
                completion(false, apiResponse.message as AnyObject?, apiResponse.errorCode!)
            }
        }
    }

}
