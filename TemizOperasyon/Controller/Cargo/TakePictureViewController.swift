//
//  TakePictureViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 19.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import SwiftyCam
import AVFoundation


class TakePictureViewController: UIViewController {
    
    // Name and ID area
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    // Camera View
    @IBOutlet weak var cameraView: UIView!
    public var cameraBoundsView: UIView!
    
    // Sent Popup
    @IBOutlet weak var sentPopup: UIView!
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    
    // Camera Manager
    let cameraManager = CameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustViews()
        
        
        cameraManager.addPreviewLayerToView(self.cameraView)
        
    }
    
    func adjustViews() {
        
        if DataManager.isComingFromShoeRepair {
            
            if DataManager.sentPopupShow {
              
                self.sentPopup.isHidden = false
                DataManager.sentPopupShow = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.sentPopup.isHidden = true
                }
                
            } else {
                
                self.sentPopup.isHidden = true
                
            }
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": DataManager.shoeRepairBarcode,
                
                ] as [String : Any]
            
            print(parameters)
            
            fetchData(endpoint: "barcodes/detail", parameters: parameters as [String : AnyObject]?) { response in
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    print(json)
                    
                    if let data = json["data"] as? Dictionary<String, AnyObject> {
                        
                        let order_id = data["order_id"] as! Int
                        let username = data["username"] as! String
                        let barcode = data["barcode"] as! String
                        
                        self.nameLbl.text = username
                        self.idLbl.text = "id: \(order_id) / barkod: \(barcode)"
                        
                        
                        
                    }
                    
                    
                }
                
            }
        } else if DataManager.isComingFromStatusReady{
            
            
            
        } else {
            
            self.nameLbl.text = DataManager.selectedOrder.name
            self.idLbl.text = "Sipariş ID: \(DataManager.selectedOrder.id)"
            
            
        }
        
        nameLbl.layer.shadowColor = UIColor.black.cgColor
        nameLbl.layer.shadowRadius = 3.0
        nameLbl.layer.shadowOpacity = 1.0
        nameLbl.layer.shadowOffset = CGSize(width: 2, height: 2)
        nameLbl.layer.masksToBounds = false
        
        idLbl.layer.shadowColor = UIColor.black.cgColor
        idLbl.layer.shadowRadius = 3.0
        idLbl.layer.shadowOpacity = 1.0
        idLbl.layer.shadowOffset = CGSize(width: 2, height: 2)
        idLbl.layer.masksToBounds = false
        
        navigationItem.title = "Fotoğraf Çek"
        
    }

    @IBAction func takePicturePressed(_ sender: Any) {
        
        cameraManager.capturePictureWithCompletion { result in
            
            let photo = UIImage.init(data: result.imageData!)
            DataManager.takenImage = photo
            
            if DataManager.isComingFromDemagedProduct {
                self.performSegue(withIdentifier: "selectReason", sender: nil)
            } else if DataManager.isComingFromShoeRepair {
                self.performSegue(withIdentifier: "goShoeDemageReason", sender: nil)
            } else if DataManager.isComingFromStatusReady{
                // Change status here
                
                self.changeStatus()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        
        if DataManager.isComingFromDemagedProduct || DataManager.isComingFromShoeRepair {
            performSegue(withIdentifier: "goHome", sender: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    

}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}


// Functions for changing status cases
extension TakePictureViewController {
    
    func changeStatus() {
        
        self.loadingView.isHidden = false
        
        var imageData = UIImageJPEGRepresentation(DataManager.takenImage, 0.5)
        let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let parameters = [
            
            "token": DataManager.userToken,
            "barcode": DataManager.currentBarcode,
            "status_id": DataManager.currentStatus!,
            "image": imageStr
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
            
            self.loadingView.isHidden = true
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                if let message = json["message"] as? String {
                    
                    //TODO: Show alert and direct users to home screen when pressed ok
                    
                    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                
                                DataManager.isComingFromStatusReady = false
                                self.navigationController?.popViewController(animated: true)
                               
                        }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
            
        }
        
    }
    
}
