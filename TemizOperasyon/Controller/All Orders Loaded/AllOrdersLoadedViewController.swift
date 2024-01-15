//
//  AllOrdersLoadedViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 5.07.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class AllOrdersLoadedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Zaman Seçin"
    }

    @IBAction func morningPressed(_ sender: Any) {
        
        let parameters = [
            
            "token": DataManager.userToken,
            "type": "morning"
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "orders/package_pickup/check_all", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.dismiss(animated: true, completion: nil)
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.navigationController?.popViewController(animated: true)
                
                
            }
            
            
        }
        
    }
    
    
    @IBAction func eveningPressed(_ sender: Any) {
        
        let parameters = [
            
            "token": DataManager.userToken,
            "type": "evening"
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "orders/package_pickup/check_all", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.navigationController?.popViewController(animated: true)
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            
            
        }
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
