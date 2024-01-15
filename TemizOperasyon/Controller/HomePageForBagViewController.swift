//
//  HomePageForBagViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 9.12.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit
import BarcodeScanner
import Jelly

class HomePageForBagViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerManuelButtonDelegate  {
    
    // Buttons
    @IBOutlet weak var bagApproveButton: UIButton!
    @IBOutlet weak var bagIsReadyButton: UIButton!
    
    @IBOutlet weak var examineButton: UIButton!
    @IBOutlet weak var addRepairButton: UIButton!
    @IBOutlet weak var approvedButton: UIButton!
    
    // Barcode Mode
    var barcodeMode = "normal"
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Jelly animator
    var jellyAnimator: JellyAnimator!
    
    var isNotificationActive = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.isComingFromShoeRepair = false
        
        if !isNotificationActive {
            // Define identifier
            let notificationName = Notification.Name("manuelAreaClosed")
            
            // Register to receive notification
            NotificationCenter.default.addObserver(self, selector: #selector(HomePageForBagViewController.manuelAreaClosed), name: notificationName, object: nil)
            
            self.isNotificationActive = true
        }
        
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
        } else if DataManager.manuelBarcodeType == "shoeRepair" {
            
            self.loadingView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadingView.isHidden = true
                DataManager.isComingFromShoeRepair = true
                self.performSegue(withIdentifier: "goTakePicture", sender: nil)
            }
            
            
            
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
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)
        
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("barcode number = \(code) and type = \(type)")
        
        controller.isOneTimeSearch = true
        
        if barcodeMode == "examine" {
            
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
            
            
            
        } else if barcodeMode == "bagApprove" {
            
            controller.messageViewController.textLabel.text = "Barkod servise yükleniyor..."
            //        self.dismiss(animated: true, completion: nil)
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": code,
                "status_id": 29
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    controller.reset(animated: true)
                    controller.messageViewController.textLabel.text = json["message"] as! String
                    
                }
                
                
                
            }
            
        } else if barcodeMode == "bagIsReady" {
            
            controller.messageViewController.textLabel.text = "Barkod servise yükleniyor..."
            //        self.dismiss(animated: true, completion: nil)
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": code,
                "status_id": 7
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
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
    
    func scannerDidManuelButton(_ controller: BarcodeScannerViewController) {
        
        
        if barcodeMode == "examine" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "examine"
                self.presentPopup()
            }
            
        }
        
        
        
        if barcodeMode == "shoeRepair" {
            
            controller.dismiss(animated: true) {
                DataManager.manuelBarcodeType = "shoeRepair"
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

   
    // Actions
    
    @IBAction func bagApprovePressed(_ sender: Any) {
        
        barcodeMode = "bagApprove"
        openBarcodeView()
        
    }
    
    @IBAction func bagIsReadyPressed(_ sender: Any) {
        
        barcodeMode = "bagIsReady"
        openBarcodeView()
        
    }
    
    
    @IBAction func examineFromBarcodePressed(_ sender: Any) {
        
        barcodeMode = "examine"
        openBarcodeView()
        
    }
    
    @IBAction func addRepairPressed(_ sender: Any) {
        
        barcodeMode = "shoeRepair"
               openBarcodeView()
        
    }
    
    @IBAction func approvedPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goApproved", sender: nil)
        
    }
    
    // log Out
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "userToken")
        defaults.set(nil, forKey: "userID")
        performSegue(withIdentifier: "logOut", sender: nil)
        
    }
    
    
    
    // Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Define identifier
        let notificationName = Notification.Name("manuelAreaClosed")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        self.isNotificationActive = false
        
        
        let backItem = UIBarButtonItem()
        backItem.title = "Geri"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        
    }
}
