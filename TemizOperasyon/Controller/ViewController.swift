//
//  ViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

import UIKit
import BarcodeScanner
import Jelly

class ViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, UIPickerViewDelegate, UIPickerViewDataSource, BarcodeScannerManuelButtonDelegate {
    
    // Main Scroll View
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    // Page Container View
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var pageContainerHeight: NSLayoutConstraint!
    var isPageActive = false
    
    // Status Area
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusField: UITextField!
    
    // Search Area
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchLoading: UIActivityIndicatorView!
    
    
    // Main Table View
    @IBOutlet weak var mainTableView: UITableView!
    var tableViewHeight: CGFloat {
        mainTableView.layoutIfNeeded()
        
        return mainTableView.contentSize.height
        
    }
    
    // Jelly animator
    var jellyAnimator: JellyAnimator!
    
    // Status Picker
    var statusPicker = UIPickerView()
    
    // Barcode Mode
    var barcodeMode = "normal"
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Button Array
    var mainButtonsArray = [MainButtonModel]()
    var filteredButtonsArray = [MainButtonModel]() {
        didSet {
            self.mainTableView.reloadData()
            self.pageContainerHeight.constant = 242 + self.tableViewHeight
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.adjustViews()
        self.setupMainTableView()
        self.addRightNavigationBarButton()
        self.getStatuses()
        self.getMenuList()
        self.mainScrollView.panGestureRecognizer.delaysTouchesBegan = true
        
        self.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Define identifier
        let notificationName = Notification.Name("manuelAreaClosed")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.manuelAreaClosed), name: notificationName, object: nil)
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.productDetailClosed), name: Notification.Name("productDetailClosed"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.isComingFromDemagedProduct = false
        DataManager.isComingFromShoeRepair = false
        DataManager.isComingFromStatusReady = false
        
        navigationItem.title = DataManager.userName
    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    }
    
    func addRightNavigationBarButton() {
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Görevler", for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(ViewController.dutiesButtonPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)


        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
    }
    
    func setupMainTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "MainButtonCell", bundle: nil), forCellReuseIdentifier: "MainButtonCell")
        mainTableView.separatorStyle = .none
        mainTableView.isScrollEnabled = false
        mainTableView.tableFooterView = UIView()
        
    }
    
    @objc func dutiesButtonPressed() {
        
        self.performSegue(withIdentifier: "goDutiesPlatform", sender: nil)
        
    }
    
    @objc func manuelAreaClosed() {
        
        print("manuel alan böyle kapandı = \(DataManager.manuelBarcodeType)")
        
        if DataManager.manuelBarcodeType == "examine" {
            self.loadingView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadingView.isHidden = true
                DataManager.isComingFromHome = true
                self.performSegue(withIdentifier: "detail", sender: nil)
            }
        } else if DataManager.manuelBarcodeType == "package" {
            
            self.performSegue(withIdentifier: "goPackage", sender: nil)
            
        } else if DataManager.manuelBarcodeType == "shoeRepair" {
            
            self.loadingView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadingView.isHidden = true
                DataManager.isComingFromShoeRepair = true
                self.performSegue(withIdentifier: "goTakePicture", sender: nil)
            }
            
        } else if DataManager.manuelBarcodeType == "fromFabric" {
            
            self.loadingView.isHidden = true
            let alert = UIAlertView()
            alert.message = "Durum güncellendi"
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        } else {
            self.openBarcodeView()
        }
        
    }
    
    @objc func productDetailClosed() {
        
        
        barcodeMode = "examine"
        self.loadingView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingView.isHidden = true
            self.openBarcodeView()
        }
        
    }
    
    func adjustViews() {
        
        statusView.layer.borderWidth = 1
        statusView.layer.borderColor = UIColor.init(rgb: 0x00AB66).cgColor
       
        statusPicker.delegate = self
        statusPicker.dataSource = self
        statusField.inputView = statusPicker
        
        // Search View
        self.searchContainerView.layer.cornerRadius = 8
        
    }
    
    
    func getStatuses() {
        
        let parameters = [
            
            "token": DataManager.userToken
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "product/status_list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                DataManager.allStatuses = [statusItem]()
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let name = data[x]["name"] as! String
                        
                        let item = statusItem.init(id: id, name: name)
                        DataManager.allStatuses.append(item)
                        
                        
                    }
            
                    self.statusPicker.reloadAllComponents()
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
        }
        
    }
    
    func getMenuList() {
        
        MenuService().fetchMenuList { success, response, errorCode in

            if success {
                
                if errorCode == "01" {
                    
                } else {
                    self.mainButtonsArray = response as? [MainButtonModel] ?? []
                    self.filteredButtonsArray = self.mainButtonsArray
                    self.mainTableView.reloadData()
                }
                
            } else {
                // TODO: Show error here
                
            }
          
        }
        
    }

    func barcodePressed() {
        
        barcodeMode = "normal"
        if DataManager.currentStatus != nil {
            
            openBarcodeView()
            
        } else {
            
            let alert = UIAlertView()
            alert.message = "Lütfen bir durum seçin."
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        }
        
        
    }
    
    @objc func openBarcodeView() {
        
        
            let viewController = BarcodeScannerViewController()
            viewController.headerViewController.titleLabel.text = ""
            viewController.headerViewController.closeButton.tintColor = UIColor.init(rgb: 0x00AB66)
            viewController.headerViewController.manuelButton.tintColor = UIColor.init(rgb: 0x00AB66)
            
            viewController.codeDelegate = self
            viewController.errorDelegate = self
            viewController.dismissalDelegate = self
            viewController.manuelButtonDelegate = self
            viewController.cameraViewController.barCodeFocusViewType = .twoDimensions
            viewController.isOneTimeSearch = true
            
            present(viewController, animated: true, completion: nil)
        
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("barcode number = \(code) and type = \(type)")
        
        controller.isOneTimeSearch = true
        
        if barcodeMode == "normal" {
           
            if DataManager.currentStatus == 12 {
                // TODO: Will find what is the status for "ready" and open the camera capture screen
                DataManager.isComingFromStatusReady = true
                DataManager.currentBarcode = code
                controller.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "goTakePicture", sender: nil)
                
            } else {
                
                controller.messageViewController.textLabel.text = "Barkod servise yükleniyor..."
                //        self.dismiss(animated: true, completion: nil)
                
                let parameters = [
                    
                    "token": DataManager.userToken,
                    "barcode": code,
                    "status_id": DataManager.currentStatus!
                    
                    
                    ] as [String : Any]
                
                fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
                    
                    
                    
                    if let json = response.object as? Dictionary<String, AnyObject> {
                        
                        controller.reset(animated: true)
                        controller.messageViewController.textLabel.text = json["message"] as! String
                        
                    }
                    
                    
                    
                }
                
            }
            
        } else if barcodeMode == "examine" {
            
            controller.messageViewController.textLabel.text = "Ürün bilgileri alınıyor"
            //        self.dismiss(animated: true, completion: nil)
            
            DataManager.detailCode = code
            self.loadingView.isHidden = false
            controller.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                self.loadingView.isHidden = true
                DataManager.isComingFromHome = true
                self.performSegue(withIdentifier: "detail", sender: nil)
            }
            
        } else if barcodeMode == "assignShelf" {
            
            // Assign Shelf Here
            controller.messageViewController.textLabel.text = "Barkod bastırılıyor..."
            //        self.dismiss(animated: true, completion: nil)
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": code,
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "product/set/auto", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    controller.reset(animated: true)
                    controller.messageViewController.textLabel.text = json["message"] as! String
                    
                    
                }
                
                
                
            }
            
        } else if barcodeMode == "package" {
            
            DataManager.packageOrderId = code
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "goPackage", sender: nil)
            })
            
            
        } else if barcodeMode == "loadProduct" {
            
            
            controller.messageViewController.textLabel.text = "İşlem Yapılıyor..."
            
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": code,
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "orders/package_pickup", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    controller.messageViewController.textLabel.text = json["message"] as! String
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                        controller.reset(animated: true)
                    }
                    
                    
                    
                    
                }
                
                
                
            }
            
        } else if barcodeMode == "shoeRepair" {
            
            print("qr code = \(code)")
            DataManager.shoeRepairBarcode = code
            
            self.loadingView.isHidden = false
            controller.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                self.loadingView.isHidden = true
                DataManager.isComingFromShoeRepair = true
                self.performSegue(withIdentifier: "goTakePicture", sender: nil)
            }
            
            
            
        } else if barcodeMode == "cargo" {
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": code
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "mng/get_order_id", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    print(json)
                    DataManager.allStatuses = [statusItem]()
                    
                    if let data = json["data"] as? Dictionary<String, AnyObject> {
                        
                        let id = data["id"] as! Int
                        let name = data["name"] as! String
                        let address = data["address"] as! String
                        
                        DataManager.selectedOrder = PeopleItem.init(id: id, name: name, address: address)
                        DataManager.selectedOrderId = id
                        controller.dismiss(animated: true, completion: {
                            self.performSegue(withIdentifier: "goDirectCargo", sender: nil)
                        })
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
            }
            
        } else if barcodeMode == "storeQrCode" {
            
            let parameters = [
                
                "token": DataManager.userToken,
                "qr_code": code
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "warehouse/qr_info", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    print(json)
                    DataManager.allStatuses = [statusItem]()
                    
                    if let data = json["data"] as? Dictionary<String, AnyObject> {
                        
                        let id = data["id"] as! Int
                        let name = data["name"] as! String
                        
                        DataManager.storeID = id
                        DataManager.storeName = name
                        
                        
                        controller.dismiss(animated: true, completion: {
                            self.performSegue(withIdentifier: "goStoreQrCode", sender: nil)
                        })
                        
                        
                    } else {
                        
                        controller.dismiss(animated: true, completion: {
                            
                            let alert = UIAlertView()
                            alert.message = json["message"] as! String
                            alert.addButton(withTitle: "Tamam")
                            alert.show()
                            
                        })
                        
                    }
                    
                    
                    
                }
                
                
                
                
            }
            
        } else if barcodeMode == "fromFabric" {
            
            controller.messageViewController.textLabel.text = "Barkod servise yükleniyor..."
            
            let parameters = [
                
                "token": DataManager.userToken,
                "qr": code,
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "orders/ready_from_fabric", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
                        controller.reset(animated: true)
                    }
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
    
    func scannerDidManuelButton(_ controller: BarcodeScannerViewController) {
        
        if barcodeMode == "normal" {
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "normal"
                self.presentPopup()
            }
        }
        
        if barcodeMode == "examine" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "examine"
                self.presentPopup()
            }
            
        }
        
        if barcodeMode == "assignShelf" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "assignShelf"
                self.presentPopup()
            }
            
        }
        
        if barcodeMode == "package" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "package"
                self.presentPopup()
            }
            
        }
        
        if barcodeMode == "loadProduct" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "loadProduct"
                self.presentPopup()
            }
            
        }
        
        if barcodeMode == "shoeRepair" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "shoeRepair"
                self.presentPopup()
            }
            
        }
        
        if barcodeMode == "cargo" {
            
            
            controller.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "goOrderList", sender: nil)
            })
                
            
        }
        
        if barcodeMode == "fromFabric" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "fromFabric"
                self.presentPopup()
            }
            
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
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        UserManager.shared.logout()
        
    }
    
    // Picker Functions
    
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
        
        self.statusField.text = DataManager.allStatuses[row].name
        DataManager.currentStatus = DataManager.allStatuses[row].id
        
    }
    
    func examinateFromBarcodePressed() {
        
        barcodeMode = "examine"
        openBarcodeView()
        
    }
    
    func assignShelfIdPressed() {
        
        barcodeMode = "assignShelf"
        openBarcodeView()
        
    }
    
    func cargoPressed() {
        
        barcodeMode = "cargo"
        openBarcodeView()
        
    }
    
    func pocketMatchingPressed() {
        
        barcodeMode = "package"
        openBarcodeView()
        
    }
    
    func loadProductPressed() {
        
        barcodeMode = "loadProduct"
        openBarcodeView()
        
    }
    
    func barcodeWithMessagePressed() {
        
        performSegue(withIdentifier: "messageBarcode", sender: nil)
        
    }
    
    func allOrdersLoadedPressed() {
        
        performSegue(withIdentifier: "allOrdersLoaded", sender: nil)
        
    }
    
    func demagedProducts() {
        
        DataManager.isComingFromDemagedProduct = true
        performSegue(withIdentifier: "goOrderList", sender: nil)
        
    }
    
    func shoeDemageRepairPressed() {
        
        barcodeMode = "shoeRepair"
        openBarcodeView()
        
        
    }
    
    
    func shoePackagePressed() {
        
        performSegue(withIdentifier: "shoePackage", sender: nil)
        
    }
    
    func approvedPressed() {
        
        performSegue(withIdentifier: "goApproved", sender: nil)
        
    }
    
    func repairConsentPressed() {
        
        performSegue(withIdentifier: "goRepairConsent", sender: nil)
        
    }
    
    func newRepairNotesPressed() {
        
        performSegue(withIdentifier: "goNewRepairNotes", sender: nil)
        
    }
    
    func landToStorePressed() {
        
        DataManager.storePageType = "drop"
//        barcodeMode = "storeQrCode"
//        openBarcodeView()
        performSegue(withIdentifier: "goStoreList", sender: nil)
        
    }
    
    func pickupFromStorePressed() {
        
        DataManager.storePageType = "pickup"
//        barcodeMode = "storeQrCode"
//        openBarcodeView()
        performSegue(withIdentifier: "goStoreList", sender: nil)
    }
    
    func readyFromFabric() {
        
        barcodeMode = "fromFabric"
        openBarcodeView()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Define identifier
        let notificationName = Notification.Name("manuelAreaClosed")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Geri"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, mainButtonCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredButtonsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MainButtonCell.self, for: indexPath)
        cell.delegate = self
        let item = self.filteredButtonsArray[indexPath.row]
        cell.populateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func mainButtonPressed(id: Int) {
        
        switch id {
        case 1:
            // Toplu Durum Güncelle
            self.barcodePressed()
        case 2:
            // Barkoddan durum sorgula
            self.examinateFromBarcodePressed()
        case 3:
            // Anadolu Yakası Raf Ata
            self.assignShelfIdPressed()
        case 4:
            // Kargo Ürünü Ekle
            self.cargoPressed()
        case 5:
            // Paket Eşleştirme
            self.pocketMatchingPressed()
        case 6:
            // Ürünü Teslim Aldım
            self.loadProductPressed()
        case 7:
            // Mesajlı Barkod Bas
            self.barcodeWithMessagePressed()
        case 8:
            // Tüm Siparişler Araca Yüklendi
            self.allOrdersLoadedPressed()
        case 9:
            // KT Hasarlı Ürün Bildir
            self.demagedProducts()
        case 10:
            // Ayakkabı Hasar/Tadilat Ekle
            self.shoeDemageRepairPressed()
        case 11:
            // Ayakkabı Paketleme
            self.shoePackagePressed()
        case 12:
            // Onay Alınanlar
            self.approvedPressed()
        case 13:
            // Tadilat Onay
            self.repairConsentPressed()
        case 14:
            // Yeni Tadilat Notları
            self.newRepairNotesPressed()
        case 15:
            // Depoya Ürün İndir
            self.landToStorePressed()
        case 16:
            // Depodan Ürün Al
            self.pickupFromStorePressed()
        case 17:
            // Kuru temizleme hazıra çek
            self.readyFromFabric()
        default:
            // Default
            print("no button identified!")
        }
        
    }

    
}


// MARK: Search Implementation
extension ViewController {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        // TODO: Make search implementation
        guard let searchText = textField.text else {
            return
        }
        if searchText == "" {
            self.filteredButtonsArray = self.mainButtonsArray
        } else {
            self.filteredButtonsArray = self.mainButtonsArray.filter { $0.text?.lowercased().contains(searchText) ?? false }
        }
        
    }
    
}
