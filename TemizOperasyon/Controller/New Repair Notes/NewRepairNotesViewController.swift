//
//  NewRepairNotesViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 11.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import UIKit

class NewRepairNotesViewController: UIViewController {
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Orders Array
    var ordersArray = [CustomerModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    // No Data View
    @IBOutlet weak var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adjust Navigation Title
        navigationItem.title = "Yeni Tadilat Notları"
        
        // Adjust Table View
        self.adjustTableView()
        
        // Get Api
        self.getApi()
        
    }
    
    func adjustTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func getApi() {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,

            ] as [String : Any]
        
        print(parameters)
        
        fetchData(endpoint: "orders/list/updated_notes", parameters: parameters as [String : AnyObject]?) { response in
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                self.loadingView.isHidden = true
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    self.ordersArray = [CustomerModel]()
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let name = data[x]["name"] as! String
                        let pickup_date = data[x]["pickup_date"] as! String
                        let delivery_date = data[x]["delivery_date"] as! String
                        let status = data[x]["status"] as! String
                        
                        let item = CustomerModel.init(id: id, name: name, pickup_date: pickup_date, delivery_date: delivery_date, is_cargo: 0, status: status)
                        self.ordersArray.append(item)
                        
                    }
                    
                    if self.ordersArray.count < 1 {
                        self.tableView.isHidden = true
                    } else {
                        self.tableView.isHidden = false
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: IBActions
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        
        self.getApi()
        
    }
    

}

extension NewRepairNotesViewController: UITableViewDelegate, UITableViewDataSource, RepairNotesCellProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ordersArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepairNotesCell", for: indexPath) as! RepairNotesCell
        cell.cellProtocol = self
        
        let item = self.ordersArray[indexPath.row]
        cell.populateCell(item: item)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func printButtonPressed(id: Int) {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "order_id": id

            ] as [String : Any]
        
        print(parameters)
        
        fetchData(endpoint: "orders/print_orders_barcodes", parameters: parameters as [String : AnyObject]?) { response in
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                if let message = json["message"] as? String {
                    
                    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                
                                self.getApi()
                               
                        }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
}
