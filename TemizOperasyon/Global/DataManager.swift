//
//  DataManager.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

struct DataManager {
    
    // Internet Connection
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static var userToken = ""
    static var userName = ""
    static var userID = 0
    static var userType = 0
    
    static var currentStatus: Int!
    
    static var detailCode = ""
    
    static var allStatuses = [statusItem]()
    static var orderStatuses = [statusItem]()
    static var customerStatuses = [statusItem]()
    
    static var selectedOrderId: Int!
    static var selectedOrder: PeopleItem!
    
    // Make Status Ready
    static var isComingFromStatusReady = false
    static var currentBarcode = ""
    
    // cargo screen
    static var takenImage: UIImage!
    
    // Package Screen
    static var packageOrderId: String!
    
    // Demaged Product Based
    static var isComingFromDemagedProduct = false
    static var otherReasonText = ""
    static var demage_category_id = 0
    static var selectedProductFromPriceList: ProductModel!
    static var shoeRepairBarcode = ""
    static var isComingFromShoeRepair = false
    static var sentPopupShow = false
    
    // Shoe Package Related
    static var shoeOrderListDate = ""
    static var shoeOrderListType = ""
    static var shoeOrderListArea = ""
    static var shoeOrderSelectedOrderID = 0
    
    static var imageShowCaseArray = [ShoeDetailModel]()
    static var imageShowCaseSelectionIndex = 0
    
    static var cargoHistory = 0
    
    // Manuel Barcode Type
    static var manuelBarcodeType = "normal"
    
    // Home Screen
    static var isComingFromHome = false
    
    // Store QR Code Related
    static var storeID: Int!
    static var storeName: String!
    static var storePageType = "drop"
    static var shoeErrorArray = [String]()
    static var dryCleaningErrorArray = [String]()
    static var allErrorArray = [[String]]()
    
    static var manuelLandStoreCode = ""
    
    // Sms Message Related
    static var selectedSmsMessage: DemageReasonModel!
    
    // Duty Section Related
    static var selectedDutyForDetail: dutyModel!
    static var selectedSupportImage: UIImage!
    static var selectedImageType = ""
    static var dutySearchType = ""
    static var selectedSearchType: dutySearchModel!
    static var isComingFromTaskDetail = false
    
}
