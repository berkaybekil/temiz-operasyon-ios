//
//  ApprovedProductListViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 1.02.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit
import CollieGallery
import Jelly

class ApprovedProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusTableView: UITableView!
    
    // Approved List Array
    var approvedListArray = [ApprovedListModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Change Status
    @IBOutlet weak var changeStatusPopup: UIView!
    @IBOutlet weak var changeStatusPopupView: UIView!
    @IBOutlet weak var statusMessageField: UITextField!
    
    // Popup Status
    var popupStatus: Int!
    
    // Jelly animator
    var jellyAnimator: JellyAnimator!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.statusTableView.delegate = self
        self.statusTableView.dataSource = self

        getApprovedList()
        
    }
    
    func adjustViews() {
        
        changeStatusPopupView.layer.cornerRadius = 8
        
        navigationItem.title = "Onay Alınanlar"
        
    }
    
    func getApprovedList() {
        
        var parameters = [
            
            "token": DataManager.userToken,
        
            ] as [String : Any]
        
        
        
        fetchData(endpoint: "shoes/must_be_accepted", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.approvedListArray = [ApprovedListModel]()
                
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    
                    
                    for x in 0 ..< data.count {
                        
                        let product_images_id = data[x]["product_images_id"] as! Int
                        let user = data[x]["user"] as! String
                        let barkod = data[x]["barkod"] as! String
                        let rack = data[x]["rack"] as! String
                        let small_image = data[x]["small_image"] as! String
                        let image = data[x]["image"] as! String
                        
                        let product_status = statusItem.init(id: data[x]["product_status"]!["id"] as! Int, name: data[x]["product_status"]!["name"] as! String)
                        
                        
                        let item = ApprovedListModel.init(product_images_id: product_images_id, user: user, barkod: barkod, rack: rack, small_image: small_image, image: image, product_status: product_status)
                        
                        self.approvedListArray.append(item)
                        
                    }
                    
                    self.loadingView.isHidden = true
                    self.tableView.reloadData()
                    
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return approvedListArray.count
        } else {
            return DataManager.allStatuses.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovedListCell", for: indexPath) as! ApprovedListCell
            
            let item = approvedListArray[indexPath.row]
            
            cell.imageButton.tag = indexPath.row
            cell.removeButton.tag = indexPath.row
            cell.statusButton.tag = indexPath.row
            
            cell.configureCell(item: item)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! statusCell
            
            let item = DataManager.allStatuses[indexPath.row]
            
            cell.configureCell(item: item)
            
            return cell
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.statusTableView {
            
            self.popupStatus = approvedListArray[indexPath.row].product_status.id
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            return 360
        } else {
            return 44
        }
        
        
    }
    

    // Image Pressed
    
    @IBAction func imagePressed(_ sender: UIButton) {
        
        let mainView = UIImageView.init()
        
        let url = URL(string: approvedListArray[sender.tag].small_image)
        mainView.kf.setImage(with: url)
        
        var pictures = [CollieGalleryPicture.init(image: mainView.image!)]
        let gallery = CollieGallery(pictures: pictures)
        gallery.presentInViewController(self)
        
    }
    
    @IBAction func removePressed(_ sender: UIButton) {
        
        let parameters = [
            
            "token": DataManager.userToken,
            "product_images_id": approvedListArray[sender.tag].product_images_id
            
            ] as [String : Any]
        
        fetchData(endpoint: "shoes/must_be_accepted/set", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.loadingView.isHidden = false
                self.getApprovedList()
                
                
            }
            
            
        }
        
    }
    
    @IBAction func changeStatusPressed(_ sender: UIButton) {
        
        self.changeStatusPopup.isHidden = false
        
    }
    
    // Close Pressed
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        changeStatusPopup.isHidden = true
        
    }
    
    @IBAction func changeNowPressed(_ sender: UIButton) {
        
        if popupStatus != nil {
            
            let parameters = [
                
                "token": DataManager.userToken,
                "barcode": approvedListArray[sender.tag].barkod,
                "status_id": self.popupStatus!,
                "message": statusMessageField.text!
                
                
                ] as [String : Any]
            
            fetchData(endpoint: "product/set/status", parameters: parameters as [String : AnyObject]?) { response in
                
                
                
                if let json = response.object as? Dictionary<String, AnyObject> {
                    
                    let alert = UIAlertView()
                    alert.message = json["message"] as! String
                    alert.addButton(withTitle: "Tamam")
                    alert.show()
                    
                }
                
                self.changeStatusPopup.isHidden = true
                self.getApprovedList()
                
                
            }
            
        } else {
            
            let alert = UIAlertView()
            alert.message = "Durum seçilmedi"
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        }
        
    }
    
    @IBAction func historyPressed(_ sender: UIButton) {
        
        DataManager.detailCode = approvedListArray[sender.tag].barkod
        presentPopup()
        
    }
    
    func presentPopup() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "historyPopup")
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
