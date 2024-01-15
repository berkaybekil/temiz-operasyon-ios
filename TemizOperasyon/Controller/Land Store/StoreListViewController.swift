//
//  StoreListViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 24.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit
import BarcodeScanner

class StoreListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerManuelButtonDelegate {

    // All Stores
    var allStores = [StoreModel]()
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getStores()
        
    }
    
    func getStores() {
        
        let parameters = [
            
            "token": DataManager.userToken
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "warehouse/list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                self.allStores = [StoreModel]()
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let title = data[x]["title"] as! String
                        
                        let item = StoreModel.init(id: id, title: title)
                        self.allStores.append(item)
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
        }
        
    }
    
    // Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return allStores.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell", for: indexPath) as! StoreListCell
        
        let item = allStores[indexPath.row]
        
        cell.configureCell(text: item.title)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "warehouse_id": allStores[indexPath.row].id
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "warehouse/qr_create", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.loadingView.isHidden = true
                
                if json["errorCode"] as! String == "00" {
                    
                    let viewController = BarcodeScannerViewController()
                    viewController.headerViewController.titleLabel.text = "Barkodu Okut"
                    viewController.headerViewController.closeButton.tintColor = UIColor.init(rgb: 0x00AB66)
                    viewController.headerViewController.manuelButton.tintColor = UIColor.init(rgb: 0x00AB66)
                    
                    viewController.codeDelegate = self
                    viewController.errorDelegate = self
                    viewController.dismissalDelegate = self
                    viewController.manuelButtonDelegate = self
                    viewController.cameraViewController.barCodeFocusViewType = .twoDimensions
                    
                    
                    self.present(viewController, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertView()
                    alert.message = json["message"] as! String
                    alert.addButton(withTitle: "Tamam")
                    alert.show()
                    
                }
                
                
            }
            
        }
        
        
        
    }
    
    // Barcode Functions
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("barcode number = \(code) and type = \(type)")
        
        let parameters = [
            
            "token": DataManager.userToken,
            "qr_code": code
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "warehouse/qr_info", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                DataManager.allStatuses = [statusItem]()
                
                if let data = json["data"] as? Dictionary<String, AnyObject> {
                    
                    let id = data["id"] as! Int
                    let name = data["name"] as! String
                    
                    DataManager.storeID = id
                    DataManager.storeName = name
                    
                    
                    controller.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "goStoreQrCode", sender: nil)
                    })
                    
                    
                } else {
                    
                    controller.dismiss(animated: true, completion: {
                        
                        let alert = UIAlertView()
                        alert.message = json["message"] as! String
                        alert.addButton(withTitle: "Tamam")
                        alert.show()
                        
                    })
                    
                }
                
                
                
            }
            
            
            
            
        }
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        print("dismiss")
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func scannerDidManuelButton(_ controller: BarcodeScannerViewController) {
        
    }
    

}
