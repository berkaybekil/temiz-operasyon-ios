//
//  ProductDetailViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import Kingfisher
import CollieGallery

class ProductDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentStatusLbl: UILabel!
    
    var allHistory = [detailItem]()
    
    // Change Popup Area
    @IBOutlet weak var changePopupArea: UIView!
    @IBOutlet weak var changePopupContainer: UIView!
    @IBOutlet weak var changePopupTableView: UITableView!
    @IBOutlet weak var messageLbl: UITextField!
    var popupStatus: Int!
    
    // Order Information
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var pickupLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var allPageHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImageView: UIImageView!
    
    var orderId: Int!
    
    // Notes
    @IBOutlet weak var note1Lbl: UILabel!
    @IBOutlet weak var note2Lbl: UILabel!
    @IBOutlet weak var note3Lbl: UILabel!
    
    
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.isScrollEnabled = false
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        changePopupTableView.delegate = self
        changePopupTableView.dataSource = self
        changePopupTableView.estimatedRowHeight = 44
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProductDetailViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProductDetailViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        adjustViews()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllHistory()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if DataManager.isComingFromHome {
            
            let notificationName = Notification.Name("productDetailClosed")
            NotificationCenter.default.post(name: notificationName, object: nil)
            DataManager.isComingFromHome = false
            
        }
        
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 64{
                self.view.frame.origin.y -= 200
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 64{
                
                print(" \(self.view.frame.origin.y)")
                self.view.frame.origin.y += 200
            }
        }
    }
    
    
    
    func adjustViews() {
        
        changePopupContainer.layer.cornerRadius = 8
        changePopupContainer.clipsToBounds = true
        
        navigationItem.title = "Detay"
        
    }
    
    func getAllHistory() {
        
        self.allHistory = [detailItem]()
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "barcode": DataManager.detailCode,
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "product/get/status", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print("istenen json = \(json)")
                
                if let data = json["data"] as? Dictionary<String, AnyObject> {
                    
                    self.currentStatusLbl.text = "Son Durum: \(data["current_status"] as! String)"
                    self.orderNameLbl.text = data["user_name"] as! String
                    self.pickupLbl.text = data["pickup_date"] as! String
                    self.deliveryLbl.text = data["delivery_date"] as! String
                    let addressText = data["address"] as! String
                    
                    if data["is_cargo"] as! Bool {
                        
                        self.addressLbl.text = "\(addressText) / Kargo"
                        
                    } else {
                        
                        self.addressLbl.text = addressText
                        
                    }
                    
                    
                    let url = URL(string: data["image"] as! String)
                    self.orderId = data["order_id"] as! Int
                    self.productImageView.kf.setImage(with: url,completionHandler: { (image, error, cache, url) in
                        
                        
                        
                        
                    })
                    
                    self.addressLbl.sizeToFit()
                    
                    if let history = data["history"] as? [Dictionary<String, AnyObject>] {
                        
                        for x in 0 ..< history.count {
                            
                            let admin_name = history[x]["admin_name"] as! String
                            let message = history[x]["message"] as! String
                            let created_at = history[x]["created_at"] as! String
                            
                            let item = detailItem.init(admin_name: admin_name, message: message, created_at: created_at)
                            self.allHistory.append(item)
                            
                        }
                        
                        
                        self.tableView.reloadData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            
                            self.loadingView.isHidden = true
                            
                            
                        }
                        
                        
                    }
                    
                    if let order_notes = data["order_notes"] as? String {
                        
                        self.note1Lbl.text = "Sipariş Notu : \(order_notes)"
                        self.note1Lbl.sizeToFit()
                        
                    }
                    
                    if let operation_notes = data["operation_notes"] as? String {
                        
                        self.note2Lbl.text = "Operasyon Notu: \(operation_notes)"
                        self.note2Lbl.sizeToFit()
                        
                    }
                    
                    if let admin_notes = data["admin_notes"] as? String {
                        
                        self.note3Lbl.text = "Tedarikçi Notu : \(admin_notes)"
                        self.note3Lbl.sizeToFit()
                        
                    }
                    
                } else {
                    
                    self.loadingView.isHidden = true
                    let alert = UIAlertView()
                    alert.message = json["message"] as! String
                    alert.addButton(withTitle: "Tamam")
                    alert.show()
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
                
            }
            
            
            
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            
            return allHistory.count
            
        } else {
            
            return DataManager.allStatuses.count
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! detailCell
            
            let item = allHistory[indexPath.row]
            
            cell.configureCell(item: item)
            
            self.tableView.layoutIfNeeded()
            self.allPageHeight.constant = 526 + self.tableView.contentSize.height + 150
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! statusCell
            
            let item = DataManager.allStatuses[indexPath.row]
            
            cell.configureCell(item: item)
            
            return cell
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == changePopupTableView {
            
            self.popupStatus = DataManager.allStatuses[indexPath.row].id
            
        }
        
    }
    
    @IBAction func changePressed(_ sender: Any) {
        // popup'ı aç
        changePopupArea.isHidden = false
        
    }
    
    @IBAction func changeCancelPressed(_ sender: Any) {
        // Popup'ı kapa
        changePopupArea.isHidden = true
        
    }
    
    @IBAction func changeChangePressed(_ sender: Any) {
        // değiştirme işlemini yap
        
        
        
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
                
                self.loadingView.isHidden = false
                
                let parameters = [
                    
                    "token": DataManager.userToken,
                    "barcode": DataManager.detailCode,
                    "status_id": self.popupStatus!,
                    "message": messageLbl.text!
                    
                    
                    ] as [String : Any]
                
                print(parameters)
                
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
                    self.getAllHistory()
                    
                    
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
    
    // Image Pressed
    
    @IBAction func imagePressed(_ sender: Any) {
        
        var pictures = [CollieGalleryPicture.init(image: productImageView.image!)]
        let gallery = CollieGallery(pictures: pictures)
        gallery.presentInViewController(self)
        
    }
    
    // Package Barcode
    @IBAction func packageBarcodePressed(_ sender: Any) {
        
        let parameters = [
            
            "token": DataManager.userToken,
            "order_id": orderId,
            "is_cargo": false
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "orders/print/address", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                
                
                
            }
            
            
            
        }
        
    }
    
    @IBAction func cargoPackageBarcodePressed(_ sender: Any) {
        
        let parameters = [
            
            "token": DataManager.userToken,
            "order_id": orderId,
            "is_cargo": true
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "orders/print/address", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                
                
                
            }
            
            
            
        }
        
    }
    
    @IBAction func printBarcodePressed(_ sender: Any) {
        
        let parameters = [
            
            "token": DataManager.userToken,
            "barcode": orderId,
            
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "barcodes/print/again_for_barcode", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                
                print(json)
                
            }
            
            
            
        }
        
    }
    
    
    // Go Order Pressed
    
    @IBAction func goOrderPressed(_ sender: Any) {
        
        DataManager.shoeOrderSelectedOrderID = orderId
        performSegue(withIdentifier: "goOrder", sender: nil)
        
    }
    
}
