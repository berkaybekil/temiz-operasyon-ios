//
//  CustomerAndShoeListViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 22.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class CustomerAndShoeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Container View Height
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    // Page Control Area
    @IBOutlet weak var customerArea: UIView!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var shoeArea: UIView!
    @IBOutlet weak var shoeLbl: UILabel!
    
    var pageType = "customer"
    
    // Status Filter View
    @IBOutlet weak var statusFilterView: UIView!
    @IBOutlet weak var statusFilterField: UITextField!
    
    // CustomerTableView
    @IBOutlet weak var customerTableView: UITableView!
    var customerArray = [CustomerModel]()
    var rawCustomerArray = [CustomerModel]()
    
    // Status Picker
    var statusPicker = UIPickerView()
    var currentStatus: statusItem!
    
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Status Array
    var orderStatusArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerTableView.delegate = self
        customerTableView.dataSource = self
        customerTableView.isScrollEnabled = false
        
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
        adjustViews()
        adjustToolBar()
        getOrderStatus()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingView.isHidden = false
        
        getCustomers()
        
    }
    
    func adjustViews() {
        
        statusFilterView.layer.borderWidth = 1
        statusFilterView.layer.borderColor = UIColor.init(rgb: 0x00AB66).cgColor
        
        
        customerTableView.isHidden = false
        
        navigationItem.title = "Sipariş Listeleme"
        
    }
    
    func getOrderStatus() {
        
        let parameters = [
            
            "token": DataManager.userToken
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "orders/status_list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                DataManager.orderStatuses = [statusItem]()
                
            }
            
            
        }
            
        
        
    }
    
    func adjustToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CustomerAndShoeListViewController.filterArray))
        doneButton.tintColor = UIColor(rgb: 0x2DC34B)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Filtreyi Sıfırla", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("cancelFilter")))
        cancelButton.tintColor = UIColor(rgb: 0x2981D9)
        
        // Toolbar Assigning
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Toolbar Field Assigning
        statusFilterField.inputAccessoryView = toolBar
        
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
        statusFilterField.inputView = statusPicker
        
    }
    
    
     @objc func filterArray() {
        
        if currentStatus != nil {
            var newCustomerArray = [CustomerModel]()
            
            for x in 0 ..< rawCustomerArray.count {
                
                if rawCustomerArray[x].status == currentStatus.name {
                    newCustomerArray.append(rawCustomerArray[x])
                } else {
                    print("status name \(rawCustomerArray[x].status)")
                }
                
            }
            
            customerArray = newCustomerArray
            self.containerViewHeight.constant = CGFloat(170 + self.customerArray.count * 120)
            
            self.view.endEditing(true)
            self.customerTableView.reloadData()
        } else {
            
            let alert = UIAlertController(title: "", message: "Lütfen bir statü seçiniz.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                
                self.view.endEditing(true)
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    @objc func cancelFilter() {
        
        customerArray = rawCustomerArray
        self.containerViewHeight.constant = CGFloat(170 + self.customerArray.count * 120)
        self.statusFilterField.text = "Seçiniz"
        self.view.endEditing(true)
        self.customerTableView.reloadData()
        
    }
    
    func getCustomers() {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "date": DataManager.shoeOrderListDate,
            "type": DataManager.shoeOrderListType,
            "area": DataManager.shoeOrderListArea,
            "history_show": DataManager.cargoHistory
            
            
            ] as [String : Any]
        
        print(parameters)
        
        fetchData(endpoint: "shoes/order_list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.customerArray = [CustomerModel]()
                self.rawCustomerArray = [CustomerModel]()
                DataManager.customerStatuses = [statusItem]()
                
                self.loadingView.isHidden = true
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let name = data[x]["name"] as! String
                        let pickup_date = data[x]["pickup_date"] as! String
                        let delivery_date = data[x]["delivery_date"] as! String
                        let is_cargo = data[x]["is_cargo"] as! Int
                        let status = data[x]["status"] as! String
                        
                        
                        let item = CustomerModel.init(id: id, name: name, pickup_date: pickup_date, delivery_date: delivery_date, is_cargo: is_cargo, status: status)
                        
                        self.customerArray.append(item)
                        self.rawCustomerArray.append(item)
                        
                    }
                    
                    self.containerViewHeight.constant = CGFloat(170 + self.customerArray.count * 120)
                    self.customerTableView.reloadData()
                    
                }
                
                if let filter_text = json["filter_text"] as? [Dictionary<String, AnyObject>] {
                    
                    DataManager.customerStatuses.append(statusItem.init(id: 0, name: "seçiniz"))
                    
                    for x in 0 ..< filter_text.count {
                        
                        let id = filter_text[x]["id"] as! Int
                        let name = filter_text[x]["name"] as! String
                        
                        let item = statusItem.init(id: id, name: name)
                        DataManager.customerStatuses.append(item)
                        
                    }
                    
                    self.statusPicker.reloadAllComponents()
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return customerArray.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! customerCell
        
        let item = customerArray[indexPath.row]
        
        cell.configureCell(item: item)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        DataManager.shoeOrderSelectedOrderID = customerArray[indexPath.row].id
        performSegue(withIdentifier: "shoeDetail", sender: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if pageType == "customer" {
            return 120
        } else {
            return 140
        }
        
        
    }
    

    // Page Control Actions
    
    @IBAction func customerPressed(_ sender: Any) {
        
        self.pageType = "customer"
        
        customerLbl.textColor = UIColor.white
        customerArea.backgroundColor = UIColor.init(rgb: 0x00AB66)
        
        shoeLbl.textColor = UIColor.init(rgb: 0x00AB66)
        shoeArea.backgroundColor = UIColor.white
        
        customerTableView.isHidden = false
        
        customerTableView.reloadData()
        
    }
    
    @IBAction func shoePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goShoeList", sender: nil)
        
    }
    
    // Picker View Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return DataManager.customerStatuses.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return DataManager.customerStatuses[row].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row != 0 {
            self.statusFilterField.text = DataManager.customerStatuses[row].name
            self.currentStatus = DataManager.customerStatuses[row]
        }
        
        
    }
    
    // Close Pressed
    
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
