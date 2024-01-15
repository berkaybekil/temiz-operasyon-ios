//
//  NetworkApiClient.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias ResponseHandler = (ApiResponse) -> Void

class NetworkApiClient {

    func callApi<ResponseType>(request: ApiRequest<ResponseType>, responseHandler: @escaping ResponseHandler) {

        let urlRequest = urlRequestWith(apiRequest: request)
        Alamofire.request(urlRequest).responseData { (response) in
            switch(response.result) {
            case .success:
                let apiResponse = self.successResponse(request: request, response: response)
                responseHandler(apiResponse)
            case .failure:
                self.failureResponse(response: response)
            }
        }
    }

    func urlRequestWith<ResponseType>(apiRequest: ApiRequest<ResponseType>) -> URLRequest {
        let  completeUrl = apiRequest.webserviceUrl() + apiRequest.apiPath() +
            apiRequest.apiVersion() + apiRequest.apiResource() + apiRequest.endPoint()

        var urlRequest = URLRequest(url: URL(string: completeUrl)!)
        urlRequest.httpMethod = apiRequest.requestType().rawValue
        urlRequest.setValue(apiRequest.contentType(), forHTTPHeaderField:  "Content-Type")
        urlRequest.httpBody = try?JSONSerialization.data(withJSONObject:  apiRequest.bodyParams()!, options: [])
        return urlRequest
    }
    
    // here we are going to parse the data
    func successResponse<ResponseType: Codable>(request: ApiRequest<ResponseType>,
                                                response: DataResponse<Data>) -> ApiResponse{
        do {
            // Step 1
            let responseJson = try JSON(data: response.data!)
            
            // Step 2
            let dataJson = responseJson["data"].object
            
            // Check if data is null or not
            if ((dataJson as? NSNull) != nil) {
                
                let message = responseJson["message"].string
                let errorCode = responseJson["errorCode"].string
                
                self.checkErrorCodes(responseJson)
                
                
                return ApiResponse.init(success: true, message: message, errorCode: errorCode)
                
            }
            
            let data = try JSONSerialization.data(withJSONObject: dataJson,
                                                  options: [])
            
            // Step 3
            let decodedValue = try JSONDecoder().decode(ResponseType.self, from: data)
            
            // Step 4
            return ApiResponse.init(success: true, data: decodedValue as AnyObject)
            
        } catch {
            
            print(error.localizedDescription)
            return ApiResponse(success: false)
        }
    }
    
    func failureResponse(response: DataResponse<Data>) {
        // do something here
    }

    
    private func checkErrorCodes(_ json: JSON) {
        
        let message = json["message"].string
        let errorCode = json["errorCode"].string
        
        switch errorCode {
        case "01":
            UserManager.shared.logout()
            AlertManager.shared.showAlert(message: message ?? "")
        case "02":
            AlertManager.shared.showAlert(message: message ?? "")
        default:
            print("no special function for this case")
        }
        
    }
}


