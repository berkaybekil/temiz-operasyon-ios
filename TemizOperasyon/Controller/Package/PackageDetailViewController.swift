//
//  PackageDetailViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 23.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import BarcodeScanner

class PackageDetailViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerManuelButtonDelegate {

    @IBOutlet weak var packageIdLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

            packageIdLbl.text = "Paket ID: \(DataManager.packageOrderId!)"
            navigationItem.title = "Paket Detay"
        
        
    }
    
    @IBAction func barcodePressed(_ sender: Any) {
        
        openBarcodeView()
        
    }
    
    @objc func openBarcodeView() {
        
        
        let viewController = BarcodeScannerViewController()
        viewController.headerViewController.titleLabel.text = "Poşet ID: \(DataManager.packageOrderId!)"
        viewController.headerViewController.closeButton.tintColor = UIColor.init(rgb: 0x00AB66)
        viewController.headerViewController.manuelButton.tintColor = UIColor.init(rgb: 0x00AB66)
        
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.manuelButtonDelegate = self
        viewController.cameraViewController.barCodeFocusViewType = .twoDimensions
        
        present(viewController, animated: true, completion: nil)
        
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("barcode number = \(code) and type = \(type)")
        
        
            
        controller.messageViewController.textLabel.text = "Sorgulanıyor..."
        //        self.dismiss(animated: true, completion: nil)
        
        let parameters = [
            
            "token": DataManager.userToken,
            "order_id": DataManager.packageOrderId!,
            "barcode": code
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "product/package_control", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                controller.reset(animated: true)
                controller.messageViewController.textLabel.text = json["message"] as! String
                
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
