//
//  TransactionHistoryViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 5.02.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit


class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Main Components
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    // History Array
    var allHistory = [detailItem]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 200

        adjustViews()
        getAllHistory()
        
    }
    
    func adjustViews() {
        
        self.closeButton.layer.cornerRadius = 8
        self.tableView.layer.cornerRadius = 8
        
    }
    
    func getAllHistory() {
        
        self.allHistory = [detailItem]()
        
        var parameters = [
            
            "token": DataManager.userToken,
            "barcode": DataManager.detailCode,
            
            
            
            ] as [String : Any]
        
       
        
        fetchData(endpoint: "product/get/status", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print("istenen json = \(json)")
                
                if let data = json["data"] as? Dictionary<String, AnyObject> {
                    
                    
                    if let history = data["history"] as? [Dictionary<String, AnyObject>] {
                        
                        for x in 0 ..< history.count {
                            
                            let admin_name = history[x]["admin_name"] as! String
                            let message = history[x]["message"] as! String
                            let created_at = history[x]["created_at"] as! String
                            
                            let item = detailItem.init(admin_name: admin_name, message: message, created_at: created_at)
                            self.allHistory.append(item)
                            
                        }
                        
                        
                        self.tableView.reloadData()
                        
                        
                        
                    }
                    
                    
                    
                } else {
                    
                    
                }
                
                
            }
            
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            
            return allHistory.count
            
        } else {
            
            return 0
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! detailCell
            
            let item = allHistory[indexPath.row]
            
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
        
        
        
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

}
