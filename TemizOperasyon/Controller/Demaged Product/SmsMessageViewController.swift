//
//  SmsMessageViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 9.01.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit

class SmsMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Table View
    @IBOutlet weak var tableView: UITableView!
    var allMessagesArray = [DemageReasonModel]()
    var selectedMessage: DemageReasonModel!
    
    // Select Button
    @IBOutlet weak var selectButton: UIButton!
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        self.getList()
    }
    
    func getList() {
        
        let parameters = [
            
            "token": DataManager.userToken,
            
            
            ] as [String : Any]
        
        
        
        fetchData(endpoint: "repair/template/list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let title = data[x]["title"] as! String
                        let item = DemageReasonModel.init(id: id, reason: title)
                        self.allMessagesArray.append(item)
                        
                    }
                    
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                    
                }
                
                
                
            }
            
            
        }
        
    }
    
    // Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allMessagesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemageReasonCell", for: indexPath) as! DemageReasonCell
        
        let item = allMessagesArray[indexPath.row]
        
        cell.configureCell(item: item)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedMessage = allMessagesArray[indexPath.row]
        
    }
    
    
    @IBAction func selectPressed(_ sender: Any) {
        
        DataManager.selectedSmsMessage = self.selectedMessage
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

}
