//
//  LandStoreViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 12.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit
import BarcodeScanner
import Jelly

class LandStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerManuelButtonDelegate {

    // Store Name Lbl
    @IBOutlet weak var storeNameLbl: UILabel!
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    // Barcodes
    var barcodesArray = [String]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Jelly animator
    var jellyAnimator: JellyAnimator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Define identifier
        let notificationName = Notification.Name("manuelAreaClosed")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(LandStoreViewController.manuelAreaClosed), name: notificationName, object: nil)

        adjustViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func adjustViews() {
        
        self.loadingView.isHidden = true
        self.storeNameLbl.text = DataManager.storeName
        
    }
    
    // Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return barcodesArray.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemageReasonCell", for: indexPath) as! DemageReasonCell
        
        let item = barcodesArray[indexPath.row]
        
        cell.configureCellForStoreQr(Text: item)
        
        return cell
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.barcodesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Barcode Functions
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("barcode number = \(code) and type = \(type)")
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            controller.reset(animated: true)
            controller.messageViewController.textLabel.text = "\(code) eklendi."
            self.barcodesArray.append(code)
            self.tableView.reloadData()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            controller.dismiss(animated: true, completion: nil)
            DataManager.manuelBarcodeType = "landStore"
            self.presentManuelPopup()
        }
        
        
        
    }
    
    @objc func manuelAreaClosed() {
        
        self.barcodesArray.append(DataManager.manuelLandStoreCode)
        self.tableView.reloadData()
        
    }
    
    func presentManuelPopup() {
        
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
    
    // Actions
    
    @IBAction func addBarcodePressed(_ sender: Any) {
        
        let viewController = BarcodeScannerViewController()
        viewController.headerViewController.titleLabel.text = "Barkodu Okut"
        viewController.headerViewController.closeButton.tintColor = UIColor.init(rgb: 0x00AB66)
        viewController.headerViewController.manuelButton.tintColor = UIColor.init(rgb: 0x00AB66)
        
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.manuelButtonDelegate = self
        viewController.cameraViewController.barCodeFocusViewType = .twoDimensions
        
        
        present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func finishProcessPressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        var barcodesString = ""
        
        for x in 0 ..< self.barcodesArray.count {
            
            barcodesString += "\(self.barcodesArray[x]),"
            
        }
        
        let parameters = [
            
            "token": DataManager.userToken,
            "warehouse_id": DataManager.storeID!,
            "barcodes": barcodesString,
            "type": DataManager.storePageType
            
            
            ] as [String : Any]
        
        print(parameters)
        
        fetchData(endpoint: "warehouse/pickup_orders", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.loadingView.isHidden = true
                
                if json["errorCode"] as! String == "00" {
                    
                    let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                        
                        // Define identifier
                        let notificationName = Notification.Name("manuelAreaClosed")
                        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                } else if json["errorCode"] as! String == "02" {
                    
                    let alert = UIAlertView()
                    alert.message = json["message"] as! String
                    alert.addButton(withTitle: "Tamam")
                    alert.show()
                    
                } else {
                    
                    if let error_text_dry_clean = json["error_text_dry_clean"] as? [String] {
                        
                        for x in 0 ..< error_text_dry_clean.count {
                            
                            DataManager.dryCleaningErrorArray.append(error_text_dry_clean[x])
                            
                        }
                        
                    }
                    
                    if let error_text_shoe_shine = json["error_text_shoe_shine"] as? [String] {
                        
                        for x in 0 ..< error_text_shoe_shine.count {
                            
                            DataManager.shoeErrorArray.append(error_text_shoe_shine[x])
                            
                        }
                        
                        DataManager.allErrorArray.append(DataManager.dryCleaningErrorArray)
                        DataManager.allErrorArray.append(DataManager.shoeErrorArray)
                        
                        self.presentPopup()
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
    }
    
    func presentPopup() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ErrorPopup")
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
    

}
