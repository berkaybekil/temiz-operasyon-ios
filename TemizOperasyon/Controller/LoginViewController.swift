//
//  LoginViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // Areas
    @IBOutlet weak var emailArea: UIView!
    @IBOutlet weak var passwordArea: UIView!
    
    // Fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // Login Button
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adjustViews()
        
    }
    
    
    
    func adjustViews() {
        
        emailArea.layer.borderWidth = 1
        emailArea.layer.borderColor = UIColor.init(rgb: 0x00AB66).cgColor
        passwordArea.layer.borderWidth = 1
        passwordArea.layer.borderColor = UIColor.init(rgb: 0x00AB66).cgColor
       
        loginButton.layer.cornerRadius = 4
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let parameters = [
            
            "email": emailField.text!,
            "password": passwordField.text!
            
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "user/login", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                if let data = json["data"] as? Dictionary<String, AnyObject> {
                    
                    let token = data["token"] as! String
                    let name = data["name"] as! String
                    let id = data["id"] as! Int
                    let type = data["type"] as! Int
                    
                    let defaults = UserDefaults.standard
                    defaults.set(token, forKey: "userToken")
                    defaults.set(name, forKey: "userName")
                    defaults.set(id, forKey: "userID")
                    defaults.set(type, forKey: "userType")
                    
                    DataManager.userToken = token
                    DataManager.userName = name
                    DataManager.userID = id
                    DataManager.userType = type
                    
                    if DataManager.userType == 8 {
                        self.performSegue(withIdentifier: "goHomeBag", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }

                }
                
                if let message = json["message"] as? String {
                    
                    let alert = UIAlertView()
                    alert.message = message
                    alert.addButton(withTitle: "Tamam")
                    alert.show()
                    
                }
                
            }
            
            
            
            
        }
        
    }

}
