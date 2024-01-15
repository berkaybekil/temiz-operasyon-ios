//
//  ShoeDetailViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 22.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import BarcodeScanner
import Alamofire
import Jelly

class ShoeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerManuelButtonDelegate {
    
    

    // Container View Height
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    // Area 1
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    
    // Area 2
    @IBOutlet weak var orderNoteLbl: UILabel!
    @IBOutlet weak var operationNoteLbl: UILabel!
    @IBOutlet weak var adminNoteLbl: UILabel!
    
    // Area 3
    @IBOutlet weak var delayCountLbl: UILabel!
    @IBOutlet weak var regionLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    var shoeArray = [ShoeDetailModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Jelly animator
    var jellyAnimator: JellyAnimator!
    
    // Change Popup Area
    @IBOutlet weak var changePopupArea: UIView!
    @IBOutlet weak var changePopupContainer: UIView!
    @IBOutlet weak var changePopupTableView: UITableView!
    @IBOutlet weak var messageLbl: UITextField!
    var popupStatus: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        changePopupTableView.delegate = self
        changePopupTableView.dataSource = self
        
        // Define identifier
        let notificationName = Notification.Name("manuelAreaClosedPackage")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ShoeDetailViewController.getDetail), name: notificationName, object: nil)
        
        adjustViews()
        getDetail()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("brava")
        getDetail()
        
    }
    
    func adjustViews() {
        
        changePopupContainer.layer.cornerRadius = 8
        changePopupContainer.clipsToBounds = true
        
        navigationItem.title = "Sipariş Listeleme"
        
    }
    
    @objc func getDetail() {
        
        self.loadingView.isHidden = false
        
        self.shoeArray = [ShoeDetailModel]()
        
        let parameters = [
            
            "token": DataManager.userToken,
            "order_id": DataManager.shoeOrderSelectedOrderID,
           
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "shoes/order_detail", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                self.loadingView.isHidden = true
                
                self.shoeArray = [ShoeDetailModel]()
                
                if let data = json["data"] as? Dictionary<String, AnyObject> {
                    
                    if let order = data["order"] as? Dictionary<String, AnyObject> {
                        
                        // Area 1
                        self.nameLbl.text = order["name"] as! String
                        self.statusLbl.text = order["status"] as! String
                        self.orderStatusLbl.text = order["order_status"] as! String
                        
                        // Area 2
                        if let order_notes = order["order_notes"] as? String {
                            self.orderNoteLbl.text = "Sipariş Notu: \(order_notes)"
                        }
                        if let operation_notes = order["operation_notes"] as? String {
                            self.operationNoteLbl.text = "Operasyon Notu: \(operation_notes)"
                        }
                        if let admin_notes = order["admin_notes"] as? String {
                            self.adminNoteLbl.text = "Tedarikçi Notu: \(admin_notes)"
                        }
                        
                        // Area 3
                        if let delay_count = order["delay_count"] as? Int {
                            self.delayCountLbl.text = "Ertelenme sayısı = \(delay_count)"
                        }
                        self.regionLbl.text = order["operation_zone"] as! String
                        self.adressLbl.text = order["address"] as! String
                        
                    }
                    
                    if let products = data["products"] as? [Dictionary<String, AnyObject>] {
                        
                        for x in 0 ..< products.count {
                            
                            let id = products[x]["id"] as! Int
                            let barcode = products[x]["barcode"] as! String
                            let image = products[x]["image"] as! String
                            let product_status = products[x]["product_status"] as! String
                            let rack = products[x]["rack"] as! String
                            let is_control = products[x]["is_control"] as! Int
                            
            
                            let item = ShoeDetailModel.init(id: id, barcode: barcode, image: image, product_status: product_status, is_control: is_control, rack: rack)
                            
                            self.shoeArray.append(item)
                            
                        }
                        
                        let oderNoteLblHeight = self.orderNoteLbl.text?.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont.systemFont(ofSize: 13, weight: .regular))
                        let operationNoteLblHeight = self.operationNoteLbl.text?.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont.systemFont(ofSize: 13, weight: .regular))
                        let adminNoteLblHeight = self.adminNoteLbl.text?.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont.systemFont(ofSize: 13, weight: .regular))
                        
                        let totalLabelHeight = oderNoteLblHeight! + operationNoteLblHeight! + adminNoteLblHeight! - 48
                        
                        self.containerViewHeight.constant = CGFloat(Int(totalLabelHeight) + 600 + self.shoeArray.count * 120)
                        self.tableView.reloadData()
                        
                    }
                    
                    
                    
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            
            return shoeArray.count
            
        } else {
            
            return DataManager.allStatuses.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "shoeDetailCell", for: indexPath) as! shoeDetailCell
            
            let item = shoeArray[indexPath.row]
            
            cell.configureCell(item: item)
            cell.imageButton.tag = indexPath.row
            cell.statusButton.tag = indexPath.row
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
    
    @IBAction func cellImagePressed(_ sender: UIButton) {
        
        DataManager.imageShowCaseArray = shoeArray
        DataManager.imageShowCaseSelectionIndex = sender.tag
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
        
        
        if tableView == self.tableView {
            return 120
        } else {
            return 44
        }
    }
    
    // Package Pressed
    
    @IBAction func packagePressed(_ sender: Any) {
        
        tryPackage()
        
    }
    
    func tryPackage() {
        
        let parameters = [
            
            "token": DataManager.userToken,
            "order_id": DataManager.shoeOrderSelectedOrderID,
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "shoes/product_packed", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                let errorCode = json["errorCode"] as! String
                let message = json["message"] as! String
                
                
                
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    if errorCode == "00" {
                        
                        self.getDetail()
                        
                    } else {
                        
                        self.openBarcodeView()
                        
                    }
                    
                }
                
                
                // Add the actions
                alertController.addAction(okAction)
                
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            
            
        }
        
    }
    
    
    // Barcode Functions
    
    @objc func openBarcodeView() {
        
        
        let viewController = BarcodeScannerViewController()
        viewController.headerViewController.titleLabel.text = "Barkodu Okut"
        viewController.headerViewController.closeButton.tintColor = UIColor.init(rgb: 0x00AB66)
        viewController.headerViewController.manuelButton.tintColor = UIColor.init(rgb: 0x00AB66)
        
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.manuelButtonDelegate = self
        viewController.dismissalDelegate = self
        viewController.cameraViewController.barCodeFocusViewType = .twoDimensions
        viewController.isOneTimeSearch = true
        
        present(viewController, animated: true, completion: nil)
        
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("barcode number = \(code) and type = \(type)")
        
        controller.isOneTimeSearch = true
        controller.messageViewController.textLabel.text = "Bekleyiniz..."
        
        let parameters = [
            
            "token": DataManager.userToken,
            "barcode": code,
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "shoes/product_set_control", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
                    controller.reset(animated: true)
                    controller.messageViewController.textLabel.text = json["message"] as! String
                }
                
            }
            
            
            
        }
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        print("dismiss")
        controller.dismiss(animated: true, completion: nil)
        
        
    }


   // Close Pressed
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Print Barcode
    
    @IBAction func addressBarcodePressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        Alamofire.request("http://cok.temiz.co/adminn/orders/print/send/\(DataManager.shoeOrderSelectedOrderID)/\(DataManager.userID)").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: utf8Text, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.loadingView.isHidden = true
                }
                
                
                // Add the actions
                alertController.addAction(okAction)
                
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    @IBAction func cargoBarcodePressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        Alamofire.request("http://cok.temiz.co/adminn/orders/print/send/\(DataManager.shoeOrderSelectedOrderID)/\(DataManager.userID)?type=cargo").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: utf8Text, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.loadingView.isHidden = true
                }
                
                
                // Add the actions
                alertController.addAction(okAction)
                
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func scannerDidManuelButton(_ controller: BarcodeScannerViewController) {
        
        controller.dismiss(animated: true) {
            DataManager.manuelBarcodeType = "package"
            self.presentPopup()
        }
        
    }
    
    func presentPopup() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "manuel")
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
    
    // Change Popup Functions
    
    @IBAction func changePopupCancelPressed(_ sender: Any) {
        
        self.changePopupArea.isHidden = true
        
    }
    
    @IBAction func changePopupChangePressed(_ sender: Any) {
        print("istek 1")
        self.loadingView.isHidden = false
        
        if popupStatus != nil {
            print("istek 2")
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
                print("istek 3")
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
                    self.getDetail()
                    
                    
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

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
