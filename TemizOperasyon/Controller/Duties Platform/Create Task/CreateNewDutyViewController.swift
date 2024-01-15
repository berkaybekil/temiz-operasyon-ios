//
//  CreateNewDutyViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit
import Jelly

class CreateNewDutyViewController: UIViewController {

    
    // Images
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    
    
    // Image Buttons
    @IBOutlet weak var imageOneButton: UIButton!
    @IBOutlet weak var imageTwoButton: UIButton!
    @IBOutlet weak var imageThreeButton: UIButton!
    @IBOutlet weak var imageFourButton: UIButton!
    
    // Fields
    @IBOutlet weak var signedAdminField: UITextField!
    @IBOutlet weak var signedAdminImage: UIImageView!
    
    @IBOutlet weak var signedGroupField: UITextField!
    @IBOutlet weak var signedGroupImage: UIImageView!
    
    @IBOutlet weak var relatedOrderField: UITextField!
    @IBOutlet weak var relatedOrderImage: UIImageView!
    
    @IBOutlet weak var relatedBarcodeField: UITextField!
    @IBOutlet weak var relatedBarcodeImage: UIImageView!
    
    @IBOutlet weak var relatedUserField: UITextField!
    @IBOutlet weak var relatedUserImage: UIImageView!
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    
    // Fields Models
    var signedAdminModel: dutySearchModel!
    var signedGroupModel: dutySearchModel!
    var relatedOrderModel: dutySearchModel!
    var relatedBarcodeModel: dutySearchModel!
    var relatedUserModel: dutySearchModel!
    
    
    
    // Create Button
    @IBOutlet weak var createButton: UIButton!
    
    // Jelly animator
    var jellyAnimator: JellyAnimator!
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewDutyViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewDutyViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        adjustViews()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataManager.selectedSupportImage != nil {
            
            if DataManager.selectedImageType == "one" {
                
                self.imageOne.image = DataManager.selectedSupportImage
                self.imageOneButton.setTitle("", for: .normal)
                
            } else if DataManager.selectedImageType == "two" {
                
                self.imageTwo.image = DataManager.selectedSupportImage
                self.imageTwoButton.setTitle("", for: .normal)
                
            } else if DataManager.selectedImageType == "three" {
                
                self.imageThree.image = DataManager.selectedSupportImage
                self.imageThreeButton.setTitle("", for: .normal)
                
            } else if DataManager.selectedImageType == "four" {
                
                self.imageFour.image = DataManager.selectedSupportImage
                self.imageFourButton.setTitle("", for: .normal)
                
            }
            
            DataManager.selectedSupportImage = nil
            
        }
        
        
        if DataManager.selectedSearchType != nil {
            
            switch DataManager.dutySearchType {
            case "task/get_admin_user_list":
                print("")
                self.signedAdminField.text = DataManager.selectedSearchType.name
                self.signedAdminModel = DataManager.selectedSearchType
                
                self.signedGroupModel = nil
                self.signedGroupField.text = ""
                
            case "task/get_groups_list":
                print("")
                self.signedGroupField.text = DataManager.selectedSearchType.name
                self.signedGroupModel = DataManager.selectedSearchType
                
                self.signedAdminModel = nil
                self.signedAdminField.text = ""
            case "task/get_orders_list":
                print("")
                self.relatedOrderField.text = DataManager.selectedSearchType.name
                self.relatedOrderModel = DataManager.selectedSearchType
            case "task/get_barcodes_list":
                print("")
                self.relatedBarcodeField.text = DataManager.selectedSearchType.name
                self.relatedBarcodeModel = DataManager.selectedSearchType
            case "task/get_user_list":
                print("")
                self.relatedUserField.text = DataManager.selectedSearchType.name
                self.relatedUserModel = DataManager.selectedSearchType
            default:
                print("no type found")
            }
            
            DataManager.selectedSearchType = nil
            
        }
        
    }
    
    
    
    func adjustViews() {
        self.loadingView.isHidden = true
        
        createButton.layer.cornerRadius = 10
        
        imageOneButton.layer.borderWidth = 1
        imageTwoButton.layer.borderWidth = 1
        imageThreeButton.layer.borderWidth = 1
        imageFourButton.layer.borderWidth = 1
        
        imageOneButton.layer.borderColor = UIColor.init(rgb: 0xD9D9D9).cgColor
        imageTwoButton.layer.borderColor = UIColor.init(rgb: 0xD9D9D9).cgColor
        imageThreeButton.layer.borderColor = UIColor.init(rgb: 0xD9D9D9).cgColor
        imageFourButton.layer.borderColor = UIColor.init(rgb: 0xD9D9D9).cgColor
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        placeholderLbl.isHidden = true
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if messageTextView.text == "" || messageTextView.text == nil {
            
            placeholderLbl.isHidden = false
            
            
        }
        
       
    }
    
    func showPicker() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchPickerViewController")
        //1.
        let customPresentation = JellySlideInPresentation(dismissCurve: .linear,
                                                          presentationCurve: .linear,
                                                          cornerRadius: 0,
                                                          backgroundStyle: .dimmed(alpha: 0.8),
                                                          jellyness: .none,
                                                          duration: .normal,
                                                          directionShow: .bottom,
                                                          directionDismiss: .bottom,
                                                          widthForViewController: .fullscreen,
                                                          heightForViewController: .fullscreen,
                                                          horizontalAlignment: .center,
                                                          verticalAlignment: .center,
                                                          marginGuards: UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0),
                                                          corners: [.bottomLeft])
        
        self.jellyAnimator = JellyAnimator(presentation:customPresentation)
        self.jellyAnimator?.prepare(viewController: viewController!)
        self.present(viewController!, animated: true) {
            
        }
    }
    

    // Actions
    
    @IBAction func assignedUserPressed(_ sender: Any) {
        
        DataManager.dutySearchType = "task/get_admin_user_list"
        performSegue(withIdentifier: "goSearch", sender: nil)
        
    }
    
    @IBAction func assignedGroupPressed(_ sender: Any) {
        
        DataManager.dutySearchType = "task/get_groups_list"
        performSegue(withIdentifier: "goSearch", sender: nil)
        
    }
    
    @IBAction func relatedOrderPressed(_ sender: Any) {
        
        DataManager.dutySearchType = "task/get_orders_list"
        performSegue(withIdentifier: "goSearch", sender: nil)
        
    }
    
    @IBAction func relatedBarcodePressed(_ sender: Any) {
        
        DataManager.dutySearchType = "task/get_barcodes_list"
        performSegue(withIdentifier: "goSearch", sender: nil)
        
    }
    
    @IBAction func relatedUserPressed(_ sender: Any) {
        
        DataManager.dutySearchType = "task/get_user_list"
        performSegue(withIdentifier: "goSearch", sender: nil)
        
    }
    
    
    
    
    @IBAction func photoOnePressed(_ sender: Any) {
        
        DataManager.selectedImageType = "one"
        performSegue(withIdentifier: "takePhoto", sender: nil)
        
    }
    
    @IBAction func photoTwoPressed(_ sender: Any) {
        
        DataManager.selectedImageType = "two"
        performSegue(withIdentifier: "takePhoto", sender: nil)
        
    }
    
    @IBAction func photoThreePressed(_ sender: Any) {
        
        DataManager.selectedImageType = "three"
        performSegue(withIdentifier: "takePhoto", sender: nil)
        
    }
    
    @IBAction func photoFourPressed(_ sender: Any) {
        
        DataManager.selectedImageType = "four"
        performSegue(withIdentifier: "takePhoto", sender: nil)
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func createPressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        if self.signedAdminModel != nil || self.signedGroupModel != nil {
            
            if self.messageTextView.text != nil && self.messageTextView.text != "" {
                
                var parameters = [
                    
                    "token": DataManager.userToken,
                    "admin_user_id": self.signedAdminModel.id,
                    "message": self.messageTextView.text
                    
                    
                    
                    ] as [String : Any]
                
                if self.signedGroupField.text != "" && self.signedGroupField.text != nil {
                    
                    parameters["task_groups_id"] = self.signedGroupModel.id
                    
                }
                
                if self.relatedOrderField.text != "" && self.relatedOrderField.text != nil {
                    
                    parameters["order_id"] = self.relatedOrderModel.id
                    
                }
                
                if self.relatedBarcodeField.text != "" && self.relatedBarcodeField.text != nil {
                    
                    parameters["barcode_id"] = self.relatedBarcodeModel.id
                    
                }
                
                if self.relatedUserField.text != "" && self.relatedUserField.text != nil {
                    
                    parameters["user_id"] = self.relatedUserModel.id
                    
                }
                
                // Images Control
                
                if imageOne.image != nil {
                    
                    let imageData = UIImageJPEGRepresentation(imageOne.image!, 1.0)
                    let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    parameters["file_1"] = imageStr
                    
                }
                
                if imageTwo.image != nil {
                    
                    let imageData = UIImageJPEGRepresentation(imageTwo.image!, 1.0)
                    let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    parameters["file_2"] = imageStr
                    
                }
                
                if imageThree.image != nil {
                    
                    let imageData = UIImageJPEGRepresentation(imageThree.image!, 1.0)
                    let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    parameters["file_3"] = imageStr
                    
                }
                
                if imageFour.image != nil {
                 
                    let imageData = UIImageJPEGRepresentation(imageFour.image!, 1.0)
                    let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    parameters["file_4"] = imageStr
                    
                }
                
                
                fetchData(endpoint: "task/create", parameters: parameters as [String : AnyObject]?) { response in
                    
                    
                    
                    if let json = response.object as? Dictionary<String, AnyObject> {
                        
                        self.loadingView.isHidden = true
                        
                        if let errorCode = json["errorCode"] as? String  {
                            
                            if errorCode == "00" {
                                
                                let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                            self.navigationController?.popViewController(animated: true)
                                           
                                            
                                    }))
                                self.present(alert, animated: true, completion: nil)
                                
                            } else {
                                
                                let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                       
                                           
                                            
                                    }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
            } else {
                
                self.loadingView.isHidden = true
                
                let alert = UIAlertController(title: "", message: "Mesaj alanını boş bırakamazsınız.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                       
                            
                            
                            
                    }))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            self.loadingView.isHidden = true
            
            let alert = UIAlertController(title: "", message: "Bir kullanıcı veya grup atayın.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                   
                        
                        
                        
                }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
        
    }
    
    
    
    
}
