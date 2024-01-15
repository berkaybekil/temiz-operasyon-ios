//
//  RepairListViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 20.02.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit

class RepairListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // All Repairs Array
    var allRepairsArray = [ProductModel]()
    var selectedRepair: ProductModel!
    var filteredRepairArray = [ProductModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // searchField
    @IBOutlet weak var searchField: UITextField!
    
    // Message View
    @IBOutlet weak var messageTextView: UITextView!
    
    // SMS Messange Selecting
    @IBOutlet weak var smsMessageView: UIView!
    @IBOutlet weak var smsMessageLbl: UILabel!
    @IBOutlet weak var smsMsgChangeButton: UIButton!
    @IBOutlet weak var smsMessageAddButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tadilat Seç"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        getRepairs()
        adjustToolBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataManager.selectedSmsMessage != nil {
            
            self.smsMessageAddButton.isHidden = true
            self.smsMessageLbl.text = DataManager.selectedSmsMessage.reason
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if DataManager.selectedSmsMessage != nil {
            
            DataManager.selectedSmsMessage = nil
            
        }
    }
    
    
    func adjustToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(RepairListViewController.hideKeyboard))
        doneButton.tintColor = UIColor(rgb: 0x2DC34B)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("cancelPressed")))
        cancelButton.tintColor = UIColor(rgb: 0x2981D9)
        
        // Toolbar Assigning
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Toolbar Field Assigning
        searchField.inputAccessoryView = toolBar
        messageTextView.inputAccessoryView = toolBar
        
    }
    
    @objc func hideKeyboard() {
        
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("text field changed")
        self.filteredRepairArray = [ProductModel]()
        
        if searchField.text != nil && searchField.text != "" {
            for x in 0 ..< self.allRepairsArray.count {
                
                var controlString = "\(self.allRepairsArray[x].name)"
                controlString = controlString.lowercased()
                
                controlString = controlString.replacingOccurrences(of: "ı", with: "i")
                controlString = controlString.replacingOccurrences(of: "ö", with: "o")
                controlString = controlString.replacingOccurrences(of: "ü", with: "u")
                controlString = controlString.replacingOccurrences(of: "ş", with: "s")
                controlString = controlString.replacingOccurrences(of: "ğ", with: "g")
                controlString = controlString.replacingOccurrences(of: "ç", with: "c")
                
                print(controlString)
                
                var searchString = searchField.text!.lowercased()
                searchString = searchString.replacingOccurrences(of: "ı", with: "i")
                searchString = searchString.replacingOccurrences(of: "ö", with: "o")
                searchString = searchString.replacingOccurrences(of: "ü", with: "u")
                searchString = searchString.replacingOccurrences(of: "ş", with: "s")
                searchString = searchString.replacingOccurrences(of: "ğ", with: "g")
                searchString = searchString.replacingOccurrences(of: "ç", with: "c")
                
                
                
                if controlString.contains(searchString) {
                    
                    self.filteredRepairArray.append(self.allRepairsArray[x])
                    
                }
                
            }
            
        } else {
            self.filteredRepairArray = self.allRepairsArray
        }
        
        if filteredRepairArray.count == 0 {
            
            // No product
            print("ürün bulunamadı")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func getRepairs() {
        
        
        
        var parameters = [
            
            "token": DataManager.userToken,
            
            
            ] as [String : Any]
        
        
        
        fetchData(endpoint: "repair/list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let name = data[x]["name"] as! String
                        let item = ProductModel.init(id: id, name: name, image: "")
                        self.allRepairsArray.append(item)
                        
                    }
                    self.filteredRepairArray = self.allRepairsArray
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                    
                }
                
                
                
            }
            
            
        }
        
    }
    
    // Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredRepairArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! productCell
        
        cell.mainImgButton.tag = indexPath.row
        
        let item = filteredRepairArray[indexPath.row]
        
        cell.configureCell(item: item)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRepair = filteredRepairArray[indexPath.row]
        
    }
    
    
    
    
    // Submit Pressed
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        if self.selectedRepair == nil {
            
            self.loadingView.isHidden = true
            let alert = UIAlertView()
            alert.message = "Önce bir ürün seçin ve mesajınızı girin."
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        } else {
            
            let imageData = UIImageJPEGRepresentation(DataManager.takenImage, 0.25)
            let imageStr = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            var parameters = [
                
                "token": DataManager.userToken,
                "barcode": DataManager.shoeRepairBarcode,
                "demage_category_id": DataManager.demage_category_id,
                "repair_id": selectedRepair.id,
                "message": self.messageTextView.text,
                "image": imageStr!,
                
                ] as [String : Any]
            
            if DataManager.selectedSmsMessage != nil {
                parameters["repair_template_id"] = DataManager.selectedSmsMessage.id
            }
            
            
            print(parameters)
            
            
            fetchData(endpoint: "repair/add", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    print(json)
                    self.loadingView.isHidden = true
                    DataManager.sentPopupShow = true
                    if let viewControllers = self.navigationController?.viewControllers {
                        if viewControllers.count > 3 {
                            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        } else {
                            // fail
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    @IBAction func smsMessagePressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "smsMessage", sender: nil)
        
    }
    

}
