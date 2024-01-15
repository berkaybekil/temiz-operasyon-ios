//
//  ManuelSendingViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class ManuelSendingViewController: UIViewController {
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataManager.manuelBarcodeType == "fromFabric" {
            self.codeField.text = ""
        }
        
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        loadingView.isHidden = false
        
        if DataManager.manuelBarcodeType == "normal" {
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": codeField.text!,
                "status_id": DataManager.currentStatus!
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    let notificationName = Notification.Name("manuelAreaClosed")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                    
                }
                
                
                
            }
            
        } else if DataManager.manuelBarcodeType == "package" {
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": codeField.text!,
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "shoes/product_set_control", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
                        self.dismiss(animated: true, completion: nil)
                        
                        let notificationName = Notification.Name("manuelAreaClosedPackage")
                        NotificationCenter.default.post(name: notificationName, object: nil)
                    }
                    
                }
                
                
                
            }
            
        } else if DataManager.manuelBarcodeType == "examine" {
            
            DataManager.detailCode = codeField.text!
            self.dismiss(animated: true, completion: nil)
            
            let notificationName = Notification.Name("manuelAreaClosed")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
        } else if DataManager.manuelBarcodeType == "assignShelf" {
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": codeField.text!,
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "product/set/auto", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    let notificationName = Notification.Name("manuelAreaClosed")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                    
                    
                }
                
                
                
            }
            
        } else if DataManager.manuelBarcodeType == "package" {
            
            DataManager.packageOrderId = codeField.text!
            self.dismiss(animated: true, completion: nil)
            
            let notificationName = Notification.Name("manuelAreaClosed")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
        } else if DataManager.manuelBarcodeType == "loadProduct" {
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": codeField.text!,
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "orders/package_pickup", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    let notificationName = Notification.Name("manuelAreaClosed")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                    
                }
                
                
                
            }
            
        } else if DataManager.manuelBarcodeType == "shoeRepair" {
            
            DataManager.shoeRepairBarcode = codeField.text!
            self.dismiss(animated: true, completion: nil)
            
            let notificationName = Notification.Name("manuelAreaClosed")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
        } else if DataManager.manuelBarcodeType == "landStore" {
            
            DataManager.manuelLandStoreCode = codeField.text!
            self.dismiss(animated: true, completion: nil)
            
            let notificationName = Notification.Name("manuelAreaClosed")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
        } else if DataManager.manuelBarcodeType == "fromFabric" {
            
            self.loadingView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                let parameters = [
                    
                    "token": DataManager.userToken,
                    "qr": self.codeField.text,
                    
                    
                    ] as [String : Any]
                
                fetchData(endpoint: "orders/ready_from_fabric", parameters: parameters as [String : AnyObject]?) { response in
                    
                    
                    
                    if let json = response.object as? Dictionary<String, AnyObject> {
                        
                        self.dismiss(animated: true, completion: nil)
                        
                        let notificationName = Notification.Name("manuelAreaClosed")
                        NotificationCenter.default.post(name: notificationName, object: nil)
                        
                    }
                    
                    
                    
                }
                
            }
        }
        
        
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
