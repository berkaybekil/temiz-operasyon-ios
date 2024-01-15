//
//  MyDutiesViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 10.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit

class MyDutiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Page Title
    @IBOutlet weak var pageTitleLbl: UILabel!
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    // Duties Array
    var myDutiesArray = [dutyModel]()
    var sortedDutiesArary = [dutyModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // Search Area
    @IBOutlet weak var searchField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
            self.sortedDutiesArary = self.myDutiesArray
                       self.tableView.reloadData()
        } else {
            self.sortedDutiesArary = [dutyModel]()
            
            for x in 0 ..< myDutiesArray.count {
                
                let searchString: String = searchField.text!
                
                if myDutiesArray[x].admin_user_name.lowercased().contains(searchString) || myDutiesArray[x].barcode_number.lowercased().contains(searchString) || myDutiesArray[x].subject.lowercased().contains(searchString) {
                    
                    self.sortedDutiesArary.append(self.myDutiesArray[x])
                    
                    
                }
                
            }
            
            self.tableView.reloadData()
        }
        
        
        
        
    }
    
    func getData() {
        
        self.loadingView.isHidden = false
        self.myDutiesArray = [dutyModel]()
        
        
        let parameters = [
            
            "token": DataManager.userToken
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "task/list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                if let data = json["data"] as? Dictionary<String, AnyObject> {
                    
                    if let tasks = data["tasks"] as? [Dictionary<String, AnyObject>] {
                        
                        for x in 0 ..< tasks.count {
                            
                            let id = tasks[x]["id"] as! Int
                            print("id budur = \(id)")
                            let order_id = tasks[x]["order_id"] as! Int
                            let admin_user_name = tasks[x]["admin_user_name"] as! String
                            let from_admin_user_name = tasks[x]["from_admin_user_name"] as! String
                            let task_groups_name = tasks[x]["task_groups_name"] as! String
                            let subject = tasks[x]["subject"] as! String
                            let message = tasks[x]["message"] as! String
                            let user_name = tasks[x]["user_name"] as! String
                            let image_1 = tasks[x]["image_1"] as! String
                            let image_2 = tasks[x]["image_2"] as! String
                            let image_3 = tasks[x]["image_3"] as! String
                            let image_4 = tasks[x]["image_4"] as! String
                            let is_complete = tasks[x]["is_complete"] as! Int
                            let barcode_id = tasks[x]["barcode_id"] as! Int
                            let barcode_number = tasks[x]["barcode_number"] as! String
                            let barcode_image = tasks[x]["barcode_image"] as! String
                            let is_read = tasks[x]["is_read"] as! Int
                            let read_admin_user_name = tasks[x]["read_admin_user_name"] as! String
                            let due_date = tasks[x]["due_date"] as! String
                            
                            
                            
                            let item = dutyModel.init(id: id, order_id: order_id, admin_user_name: admin_user_name, from_admin_user_name: from_admin_user_name, task_groups_name: task_groups_name, subject: subject, message: message, user_name: user_name, image_1: image_1, image_2: image_2, image_3: image_3, image_4: image_4, is_complete: is_complete, barcode_id: barcode_id, barcode_number: barcode_number, barcode_image: barcode_image, is_read: is_read, read_admin_user_name: read_admin_user_name, due_date: due_date)
                            self.myDutiesArray.append(item)
                            
                        }
                        
                        self.pageTitleLbl.text = "Görevlerim (\(self.myDutiesArray.count))"
                        self.loadingView.isHidden = true
                        self.sortedDutiesArary = self.myDutiesArray
                        self.tableView.reloadData()
                        
                    }
                    
                    
                }
                
                
            }
            
            
        }
        
        
    }
    

    // TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedDutiesArary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dutyCell") as! dutyCell?
        
        let item = self.sortedDutiesArary[indexPath.row]
        cell?.configureCell(item: item)
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DataManager.selectedDutyForDetail = self.sortedDutiesArary[indexPath.row]
        performSegue(withIdentifier: "detail", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // Actions
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func newPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "new", sender: nil)
        
    }
    
    

}
