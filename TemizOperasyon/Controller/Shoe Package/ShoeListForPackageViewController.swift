//
//  ShoeListForPackageViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 19.02.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit

class ShoeListForPackageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // TableView
    @IBOutlet weak var shoeTableView: UITableView!
    var shoeArray = [ShoeModel]()
    var rawShoeArray = [ShoeModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // containerViewHeight
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    // Status Picker
    var statusPicker = UIPickerView()
    var currentStatus: statusItem!
    
    // statusFilterField
    @IBOutlet weak var statusFilterField: UITextField!
    
    // Change Popup Area
    @IBOutlet weak var changePopupArea: UIView!
    @IBOutlet weak var changePopupContainer: UIView!
    @IBOutlet weak var changePopupTableView: UITableView!
    @IBOutlet weak var messageLbl: UITextField!
    var popupStatus: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shoeTableView.delegate = self
        shoeTableView.dataSource = self
        shoeTableView.isScrollEnabled = false
        
        changePopupTableView.delegate = self
        changePopupTableView.dataSource = self
        
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
        adjustViews()
        adjustToolBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingView.isHidden = false
        getShoes()
        
    }
    
    func adjustViews() {
        
        changePopupContainer.layer.cornerRadius = 8
        changePopupContainer.clipsToBounds = true
        
        navigationItem.title = "Sipariş Listeleme"
        
    }
    
    func adjustToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShoeListForPackageViewController.filterArray))
        doneButton.tintColor = UIColor(rgb: 0x2DC34B)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Filtreyi Sıfırla", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShoeListForPackageViewController.cancelFilter))
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
    
    // Filter Array
    
    @objc func filterArray() {
        
        if currentStatus != nil {
            
            var newShoeArray = [ShoeModel]()
            
            for x in 0 ..< rawShoeArray.count {
                
                if rawShoeArray[x].product_status == currentStatus.name {
                    newShoeArray.append(rawShoeArray[x])
                }
                
            }
            
            shoeArray = newShoeArray
            self.containerViewHeight.constant = CGFloat(170 + self.shoeArray.count * 140)
            self.shoeTableView.reloadData()
            self.view.endEditing(true)
            
        } else {
            
            let alert = UIAlertController(title: "", message: "Lütfen bir statü seçiniz.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                
                self.view.endEditing(true)
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    @objc func cancelFilter() {
        
        shoeArray = rawShoeArray
        self.containerViewHeight.constant = CGFloat(170 + self.shoeArray.count * 140)
        self.statusFilterField.text = "Seçiniz"
        self.shoeTableView.reloadData()
        self.view.endEditing(true)
        
    }
    
    func getShoes() {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "date": DataManager.shoeOrderListDate,
            "type": DataManager.shoeOrderListType,
            "area": DataManager.shoeOrderListArea,
            "history_show": DataManager.cargoHistory
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "shoes/product_list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                self.loadingView.isHidden = true
                self.shoeArray = [ShoeModel]()
                self.rawShoeArray = [ShoeModel]()
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let barcode = data[x]["barcode"] as! String
                        let rack = data[x]["rack"] as! String
                        let image = data[x]["image"] as! String
                        let product_status = data[x]["product_status"] as! String
                        
                        
                        
                        let item = ShoeModel.init(id: id, barcode: barcode, rack: rack, image: image, product_status: product_status)
                        
                        self.shoeArray.append(item)
                        self.rawShoeArray.append(item)
                        
                    }
                    
                    self.containerViewHeight.constant = CGFloat(170 + self.shoeArray.count * 140)
                    self.shoeTableView.reloadData()
                    
                }
                
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if tableView == self.shoeTableView {
            
            return shoeArray.count
            
        } else {
            
            return DataManager.allStatuses.count
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if tableView == self.shoeTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "shoeCell", for: indexPath) as! shoeCell
            
            let item = shoeArray[indexPath.row]
            
            cell.configureCell(item: item)
            cell.imageButton.tag = indexPath.row
            cell.changeStatusButton.tag = indexPath.row
            cell.detailButton.tag = indexPath.row
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! statusCell
            
            let item = DataManager.allStatuses[indexPath.row]
            
            cell.configureCell(item: item)
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView == self.changePopupTableView {
            
            self.popupStatus = DataManager.allStatuses[indexPath.row].id
            
        }
        
    }
    
    @IBAction func cellİmagePressed(_ sender: UIButton) {
        
        let item = ShoeDetailModel.init(id: shoeArray[sender.tag].id, barcode: shoeArray[sender.tag].barcode, image: shoeArray[sender.tag].image, product_status: shoeArray[sender.tag].product_status, is_control: 0, rack: shoeArray[sender.tag].rack)
        DataManager.imageShowCaseArray.append(item)
        performSegue(withIdentifier: "images", sender: nil)
        
    }
    
    @IBAction func changeStatusPressed(_ sender: UIButton) {
        
        DataManager.detailCode = shoeArray[sender.tag].barcode
        self.changePopupArea.isHidden = false
        
    }
    
    @IBAction func detailPressed(_ sender: UIButton) {
        
        DataManager.detailCode = shoeArray[sender.tag].barcode
        performSegue(withIdentifier: "goDetail", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.shoeTableView {
            return 140
        } else {
            return 44
        }
        
        
        
    }
    
    // Picker View Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return DataManager.allStatuses.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return DataManager.allStatuses[row].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.statusFilterField.text = DataManager.allStatuses[row].name
        self.currentStatus = DataManager.allStatuses[row]
        
    }
    
    // Close Pressed
    @IBAction func closePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goBack", sender: nil)
        
    }
    
    // Customer Pressed
    @IBAction func customerPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // Change Popup Functions
    
    @IBAction func changePopupCancelPressed(_ sender: Any) {
        
        self.changePopupArea.isHidden = true
        
    }
    
    @IBAction func changePopupChangePressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        if popupStatus != nil {
            
            if self.popupStatus == 12 {
                // Will find what is the status for "ready" and open the camera capture screen
                DataManager.isComingFromStatusReady = true
                DataManager.currentStatus = popupStatus
                DataManager.currentBarcode = DataManager.detailCode
                self.changePopupArea.isHidden = true
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let takePictureVC = storyBoard.instantiateViewController(withIdentifier: "TakePictureViewController") as! TakePictureViewController
                
                navigationController?.pushViewController(takePictureVC, animated: true)
                
                
            } else {
                
                let parameters = [
                    
                    "token": DataManager.userToken,
                    "barcode": DataManager.detailCode,
                    "status_id": self.popupStatus!,
                    "message": messageLbl.text!
                    
                    
                    ] as [String : Any]
                
                fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
                    
                    
                    
                    if let json = response.object as? Dictionary<String, AnyObject> {
                        
                        print(json)
                        
                        let alert = UIAlertView()
                        alert.message = json["message"] as! String
                        alert.addButton(withTitle: "Tamam")
                        alert.show()
                        
                    }
                    
                    self.loadingView.isHidden = true
                    self.changePopupArea.isHidden = true
                    self.getShoes()
                    
                    
                }
                
            }
            
            
            
        } else {
            
            self.loadingView.isHidden = true
            let alert = UIAlertView()
            alert.message = "Durum seçilmedi"
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        }
        
    }
    

}
