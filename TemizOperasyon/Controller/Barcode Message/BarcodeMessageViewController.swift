//
//  BarcodeMessageViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 20.06.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class BarcodeMessageViewController: UIViewController {

    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adjustViews()
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(BarcodeMessageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BarcodeMessageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    
    
    // Keyboard Functions Starts
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        placeholderLbl.isHidden = true
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if messageTextView.text == "" || messageTextView.text == nil {
            
            placeholderLbl.isHidden = false
            
        }
        
    }
    
    func adjustViews() {
        
        submitButton.layer.cornerRadius = 4
        
        messageTextView.layer.borderColor = UIColor.init(rgb: 0x00AB66).cgColor
        messageTextView.layer.borderWidth = 1
        
        navigationItem.title = "Mesajlı Barkod"
        
    }
    

    @IBAction func submitPressed(_ sender: Any) {
        
        loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "text": messageTextView.text!
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "barcodes/custom/barcode", parameters: parameters as [String : AnyObject]?) { response in
            
            self.loadingView.isHidden = true
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
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
    
    
}
