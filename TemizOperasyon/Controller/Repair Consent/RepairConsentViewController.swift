//
//  RepairConsentViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 5.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit
import CollieGallery

class RepairConsentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Tab View
    @IBOutlet weak var approvedView: UIView!
    @IBOutlet weak var approvedLbl: UILabel!
    @IBOutlet weak var rejectedView: UIView!
    @IBOutlet weak var rejectedLbl: UILabel!
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Shoes Array
    var approvedShoeArray = [ApprovedShoeModel]()
    var rejectedShoeArray = [ApprovedShoeModel]()
    var tableViewType = "approved"
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getShoes()
        
    }
    
    func getShoes() {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "repair/product/list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.approvedShoeArray = [ApprovedShoeModel]()
                self.rejectedShoeArray = [ApprovedShoeModel]()
                
                if let data = json["data"]!["yes"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let barcode = data[x]["barcode"] as! String
                        let rack = data[x]["rack"] as! String
                        let image = data[x]["image"] as! String
                        let product_status = data[x]["product_status"] as! String
                        let repair_name = data[x]["repair_name"] as! String
                        
                        
                        
                        let item = ApprovedShoeModel.init(id: id, barcode: barcode, rack: rack, image: image, product_status: product_status, repairType: repair_name)
                        
                        self.approvedShoeArray.append(item)
                        
                    }
                    
                    
                    self.loadingView.isHidden = true
                    self.tableView.reloadData()
                    
                }
                
                if let data = json["data"]!["no"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let barcode = data[x]["barcode"] as! String
                        let rack = data[x]["rack"] as! String
                        let image = data[x]["image"] as! String
                        let product_status = data[x]["product_status"] as! String
                        let repair_name = data[x]["repair_name"] as! String
                        
                        
                        
                        let item = ApprovedShoeModel.init(id: id, barcode: barcode, rack: rack, image: image, product_status: product_status, repairType: repair_name)
                        
                        self.rejectedShoeArray.append(item)
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tableViewType == "approved" {
            return approvedShoeArray.count
        } else {
            return rejectedShoeArray.count
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairConcentShoeCell", for: indexPath) as! RepairConcentShoeCell
        
        let item: ApprovedShoeModel!
        
        if self.tableViewType == "approved" {
            item = approvedShoeArray[indexPath.row]
        } else {
            item = rejectedShoeArray[indexPath.row]
        }
        
        
        
        let shoeModel = ShoeModel.init(id: item.id, barcode: item.barcode, rack: item.rack, image: item.image, product_status: item.product_status)
        
        cell.configureCell(item: shoeModel)
        cell.IDLbl.text = item.repairType
        cell.IDLbl.adjustsFontSizeToFitWidth = true
        cell.imageButton.tag = indexPath.row
        cell.changeStatusButton.tag = indexPath.row
        cell.detailButton.tag = indexPath.row
        
        
        if self.tableViewType == "approved" {
            cell.statusLbl.text = ""
            cell.cleaningButton.isHidden = true
            cell.wetRepairButton.isHidden = true
        } else {
            cell.statusLbl.text = ""
            cell.cleaningButton.isHidden = false
            cell.wetRepairButton.isHidden = false
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    @IBAction func cellİmagePressed(_ sender: UIButton) {
        
        let item: ShoeDetailModel!
        let imageView = UIImageView.init()
        
        if self.tableViewType == "approved" {
            
            let url = URL(string: approvedShoeArray[sender.tag].image)
            imageView.kf.setImage(with: url)
            
            var pictures = [CollieGalleryPicture.init(image: imageView.image!)]
            let gallery = CollieGallery(pictures: pictures)
            gallery.presentInViewController(self)
            
        } else {
            
            let url = URL(string: rejectedShoeArray[sender.tag].image)
            imageView.kf.setImage(with: url)
            
            var pictures = [CollieGalleryPicture.init(image: imageView.image!)]
            let gallery = CollieGallery(pictures: pictures)
            gallery.presentInViewController(self)
            
        }
        
        
        
    }
    
    @IBAction func changeStatusPressed(_ sender: UIButton) {
        
        if self.tableViewType == "approved" {
            DataManager.detailCode = approvedShoeArray[sender.tag].barcode
            self.changeStatus(statusID: 25, repairID: approvedShoeArray[sender.tag].id)
        } else {
            DataManager.detailCode = rejectedShoeArray[sender.tag].barcode
            
            if sender.titleLabel?.text == "TEMİZLENİYOR" {
                self.changeStatus(statusID: 6, repairID: rejectedShoeArray[sender.tag].id)
            } else {
                self.changeStatus(statusID: 18, repairID: rejectedShoeArray[sender.tag].id)
            }
            
        }
        
        
        
        
    }
    
    func changeStatus(statusID: Int, repairID: Int) {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "repair_id": repairID,
            "status_id": statusID
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "repair/product/change_status", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.getShoes()
                
                
            }
            
            
        }
        
    }
    
    @IBAction func detailPressed(_ sender: UIButton) {
        
        if self.tableViewType == "approved" {
            DataManager.detailCode = approvedShoeArray[sender.tag].barcode
            performSegue(withIdentifier: "goDetail", sender: nil)
        } else {
            DataManager.detailCode = rejectedShoeArray[sender.tag].barcode
            performSegue(withIdentifier: "goDetail", sender: nil)
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 140
        
    }
    
    // Actions
    
    @IBAction func approvedPressed(_ sender: Any) {
        
        tableViewType = "approved"
        
        approvedView.backgroundColor = UIColor.init(rgb: 0x00AB66)
        approvedLbl.textColor = .white
        rejectedView.backgroundColor = .white
        rejectedLbl.textColor = UIColor.init(rgb: 0x00AB66)
        
        self.tableView.reloadData()
        
    }
    
    @IBAction func rejectedPressed(_ sender: Any) {
        
        tableViewType = "rejected"
        
        rejectedView.backgroundColor = UIColor.init(rgb: 0x00AB66)
        rejectedLbl.textColor = .white
        approvedView.backgroundColor = .white
        approvedLbl.textColor = UIColor.init(rgb: 0x00AB66)
        
        self.tableView.reloadData()
        
    }
    

}
