//
//  DutyDetailViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 12.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit
import Kingfisher
import CollieGallery

class DutyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Top Bar
    @IBOutlet weak var completeButton: UIButton!
    
    
    // Labels
    @IBOutlet weak var fromWhoLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var toWhoLbl: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var barcodeNoLbl: UILabel!
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendMessageField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    let imageViewForBarcode = UIImageView()
    
    
    // Chat Array
    var chatArray = [DutyChatModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMessages()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.adjustViews()
    }
    
    
    
    func adjustViews() {
        
        fromWhoLbl.text = DataManager.selectedDutyForDetail.from_admin_user_name
        timeLbl.text = DataManager.selectedDutyForDetail.due_date
        
        if DataManager.selectedSearchType != nil {
            
            toWhoLbl.text = DataManager.selectedSearchType.name
            self.changeAdminOrGroup()
            
        } else {
            
            if DataManager.selectedDutyForDetail.admin_user_name != "" {
                toWhoLbl.text = DataManager.selectedDutyForDetail.admin_user_name
            } else {
                toWhoLbl.text = DataManager.selectedDutyForDetail.task_groups_name
            }
            
        }
        
        
        
        messageLbl.text = DataManager.selectedDutyForDetail.message
        
        barcodeNoLbl.text = DataManager.selectedDutyForDetail.barcode_number
        
        if DataManager.selectedDutyForDetail.is_complete == 1 {
            
            self.completeButton.setTitle("Geri Al", for: .normal)
            
        } else {
            
            self.completeButton.setTitle("Tamamla", for: .normal)
            
        }
        
        let url = URL(string: DataManager.selectedDutyForDetail.image_1)
        imageOne.kf.setImage(with: url)
        
        let url2 = URL(string: DataManager.selectedDutyForDetail.image_2)
        imageTwo.kf.setImage(with: url2)
        
        let url3 = URL(string: DataManager.selectedDutyForDetail.image_3)
        imageThree.kf.setImage(with: url3)
        
        let url4 = URL(string: DataManager.selectedDutyForDetail.image_4)
        imageFour.kf.setImage(with: url4)
        
        let url5 = URL(string: DataManager.selectedDutyForDetail.barcode_image)
        imageViewForBarcode.kf.setImage(with: url5)
        

    }
    
    func getMessages() {
        
        self.loadingView.isHidden = false
        
        self.chatArray = [DutyChatModel]()
        
        let parameters = [
            
            "token": DataManager.userToken,
            "id": DataManager.selectedDutyForDetail.id
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "task/detail", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                self.loadingView.isHidden = true
                
                if let chat = json["chat"] as? [Dictionary<String, AnyObject>] {
                    
                    for x in 0 ..< chat.count {
                        
                        let id = chat[x]["id"] as! Int
                        let name = chat[x]["name"] as! String
                        let message = chat[x]["message"] as! String
                        let image = chat[x]["image"] as! String
                        let date = chat[x]["date"] as! String
                        let is_me = chat[x]["is_me"] as! Int
                        
                        let item = DutyChatModel.init(id: id, name: name, message: message, image: image, date: date, is_me: is_me)
                        self.chatArray.append(item)
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    
                }
                
                
            }
            
            
        }
        
    }
    
    @IBAction func goOrderPressed(_ sender: Any) {
        
        if DataManager.selectedDutyForDetail.barcode_number != "" {
            navigationController?.setNavigationBarHidden(false, animated: true)
            DataManager.detailCode = DataManager.selectedDutyForDetail.barcode_number
            performSegue(withIdentifier: "goDetail", sender: nil)
        } else {
            
        }
        
        
        
    }
    
    @IBAction func showBarcodePressed(_ sender: Any) {
        
        
        let pictures = [CollieGalleryPicture.init(image: imageViewForBarcode.image!)]
        let gallery = CollieGallery(pictures: pictures)
        gallery.presentInViewController(self)
        
    }
    
    
    
    @IBAction func imagesPressed(_ sender: Any) {
        
        var pictures = [CollieGalleryPicture]()
        
        if imageOne.image != nil {
            pictures.append(CollieGalleryPicture.init(image: imageOne.image!))
        }
        
        if imageTwo.image != nil {
            pictures.append(CollieGalleryPicture.init(image: imageTwo.image!))
        }
        
        if imageThree.image != nil {
            pictures.append(CollieGalleryPicture.init(image: imageThree.image!))
        }
        
        if imageFour.image != nil {
            pictures.append(CollieGalleryPicture.init(image: imageFour.image!))
        }
        
        let gallery = CollieGallery(pictures: pictures)
        
        if pictures.count > 0 {
            gallery.presentInViewController(self)
        } else {
            print("no images")
        }
        
        
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func completePressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        var type = ""
        
        if DataManager.selectedDutyForDetail!.is_complete == 1 {
            type = "undo"
        } else {
            type = "complete"
        }
        
        let parameters = [
            
            "token": DataManager.userToken,
            "id": DataManager.selectedDutyForDetail.id,
            "type": type
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "task/set_status", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                self.loadingView.isHidden = true
                
                if let errorCode = json["errorCode"] as? String {
                    
                    if errorCode == "00" {
                        // No Problem
                        let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                               
                                    if DataManager.selectedDutyForDetail.is_complete == 1 {
                                        self.completeButton.setTitle("Tamamla", for: .normal)
                                        DataManager.selectedDutyForDetail.is_complete = 0
                                    } else {
                                        self.completeButton.setTitle("Geri Al", for: .normal)
                                        DataManager.selectedDutyForDetail.is_complete = 1
                                    }
                                    
                                    
                                    
                            }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        // Print Message
                        
                        let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                               
                            }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "id": DataManager.selectedDutyForDetail.id,
            "message": sendMessageField.text
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "task/add_chat", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                if let errorCode = json["errorCode"] as? String {
                    
                    if errorCode == "00" {
                        // No Problem
                        let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                               
                                    self.sendMessageField.text = ""
                                    
                                    self.getMessages()
                                    
                                    
                            }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        // Print Message
                        
                        let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                      self.loadingView.isHidden = true
                            }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    @IBAction func changePressed(_ sender: Any) {
        
        DataManager.isComingFromTaskDetail = true
        performSegue(withIdentifier: "goSearch", sender: nil)
        
    }
    
    func changeAdminOrGroup() {
        
        self.loadingView.isHidden = false
        
        var parameters = [
            
            "token": DataManager.userToken,
            "id": DataManager.selectedDutyForDetail.id
                
            
            ] as [String : Any]
        
        if DataManager.selectedDutyForDetail.admin_user_name != "" {
            
            parameters["admin_user_id"] = DataManager.selectedSearchType.id
            
        } else {
            
            parameters["task_groups_id"] = DataManager.selectedSearchType.id
            
        }
        
        fetchData(endpoint: "task/create", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                DataManager.selectedSearchType = nil
                self.loadingView.isHidden = true
                
                
                if let errorCode = json["errorCode"] as? String {
                    
                    if errorCode == "00" {
                        // No Problem
                        let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                               
                                    
                                    
                                    
                            }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        // Print Message
                        
                        let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                      self.loadingView.isHidden = true
                            }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    
    
    // TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dutyChatCell") as! dutyChatCell?
        
        let item = self.chatArray[indexPath.row]
        cell?.configureCell(item: item)
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
   

}
