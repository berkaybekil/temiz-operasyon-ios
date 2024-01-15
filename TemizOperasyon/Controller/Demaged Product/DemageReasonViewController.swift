//
//  DemageReasonViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 11.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class DemageReasonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var allReasons = [DemageReasonModel]()
    
    var reasonID = 0
    
    @IBOutlet weak var loadingView: UIView!
    
    // Other Reason Area
    @IBOutlet weak var otherReasonContainerArea: UIView!
    @IBOutlet weak var otherReasonArea: UIView!
    @IBOutlet weak var otherReasonTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        adjustViews()
        getReasons()
        
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if otherReasonTextView.isFirstResponder {

                if otherReasonTextView.text == "Diğer -" {
                    otherReasonTextView.text = ""
                }
                
            }
        }
    }
    
    func adjustViews() {
        
        self.otherReasonArea.layer.cornerRadius = 4
        
        navigationItem.title = "Sebep Seç"
        
    }
    
    func getReasons() {
        
        self.loadingView.isHidden = false
        
        var parameters = [
            
            "token": DataManager.userToken,
            
            
            ] as [String : Any]
        
        
        
        fetchData(endpoint: "demage/category/list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let title = data[x]["title"] as! String
                        let item = DemageReasonModel.init(id: id, reason: title)
                        
                        self.allReasons.append(item)
                        
                    }
                    
                    self.loadingView.isHidden = true
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return allReasons.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemageReasonCell", for: indexPath) as! DemageReasonCell
        
        let item = allReasons[indexPath.row]
        
        cell.configureCell(item: item)
        
        return cell
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.reasonID = allReasons[indexPath.row].id
        
        if allReasons[indexPath.row].reason == "Diğer" {
            
            self.otherReasonContainerArea.isHidden = false
            print(otherReasonTextView.text)
            
        } else {
            
        }
        
        
    }
    
    // Submit Pressed
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
        
        if self.reasonID == 0 {
            
            let alert = UIAlertView()
            alert.message = "Önce bir sebep seçin"
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        } else {
            
            DataManager.otherReasonText = otherReasonTextView.text
            DataManager.demage_category_id = self.reasonID
            
            self.performSegue(withIdentifier: "productList", sender: nil)
            
        }
        
        
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func otherReasonOkeyPressed(_ sender: Any) {
        
        otherReasonContainerArea.isHidden = true
        self.view.endEditing(true)
        
    }
    
    
    
}
