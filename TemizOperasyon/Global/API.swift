//
//  API.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



let apiUrl = "http://service.temiz.co/operation/v1/"


func fetchData(endpoint: String, parameters: [String: AnyObject]?, completion: @escaping (JSON) -> ()) {
    
    var header = [String: String]()
    
    if DataManager.userType == 8 {
        header["type"] = "bag"
    }
    
    if DataManager.isInternetAvailable() {
        
        
        Alamofire.request(apiUrl+endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
                
                print("request = \(response.request)")
                
                switch response.result {
                case .success(let value):
                    completion(JSON(value))
                case .failure(let error):
                    print(error)
                }
        }
    } else {
        
        if UIApplication.shared.keyWindow != nil {
            
        }
        
    }
    
    
    
}


