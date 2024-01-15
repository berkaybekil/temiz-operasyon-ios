//
//  CargoProductDetailViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 20.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import BarcodeScanner

class CargoProductDetailViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerManuelButtonDelegate {
    
    
    
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var barcodeLbl: UILabel!
    
    @IBOutlet weak var takenImageView: UIImageView!
    @IBOutlet weak var boxTakenImageView: UIImageView!
    var takenImageType = "productImage"
    var isBoxImageTaken = false
    
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.title = "Ürün Detay"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataManager.takenImage != nil {
            
            if takenImageType == "productImage" {
                takenImageView.image = DataManager.takenImage
            } else {
                boxTakenImageView.image = DataManager.takenImage
                self.isBoxImageTaken = true
            }
            
            
            
        }
        
    }

    @IBAction func takePhotoPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.takenImageType = "productImage"
        } else {
            self.takenImageType = "boxImage"
        }
        
        performSegue(withIdentifier: "takeImage", sender: nil)
        
    }
    
    @IBAction func takeBarcodePressed(_ sender: Any) {
        
        let viewController = BarcodeScannerViewController()
        viewController.headerViewController.titleLabel.text = "Barkodu Okut"
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
        
        barcodeLbl.text = code
        controller.dismiss(animated: true, completion: nil)
        
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
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        if takenImageView.image != UIImage.init(named: "take-photo-bg") {
            
            self.loadingView.isHidden = false
            
            var imageData = UIImageJPEGRepresentation(takenImageView.image!, 1.0)
            let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            var boxImageStr = ""
            
            if boxTakenImageView.image != UIImage.init(named: "take-photo-bg") {
                imageData = UIImageJPEGRepresentation(boxTakenImageView.image!, 1.0)
                boxImageStr = (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))!
            }
            
            
            
            let parameters = [
                
                "token": DataManager.userToken,
                "order_id": DataManager.selectedOrderId!,
                "packet_image": boxImageStr,
                "barcode": barcodeLbl.text!,
                "image": imageStr
                
                
                
                
                ] as [String : Any]
            
            print("parametreler = \(DataManager.userToken) - \(DataManager.selectedOrderId) - \(barcodeLbl.text!)")
            
            print("base 64 = \(imageStr)")
            
            fetchData(endpoint: "orders/upload/photos", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    print(json)
                    
                    
                    DataManager.selectedOrderId = nil
                    DataManager.selectedOrder = nil
                    DataManager.takenImage = nil
                    self.loadingView.isHidden = true
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
                
                
                
            }
            
        } else {
            
            let alert = UIAlertView()
            alert.message = "Lütfen önce ürünün fotoğrafını ekleyin."
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        }
        
        
        
    }
    
    
    
}
