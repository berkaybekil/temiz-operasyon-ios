//
//  SearchOrderViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 19.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class SearchOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    var allPeople = [PeopleItem]()
    
    // Submit button
    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchPeople()
        adjustViews()
        
    }
    
    func adjustViews() {
        
        if DataManager.isComingFromDemagedProduct {
            submitButton.setTitle("Fotoğraf Çek", for: .normal)
        } else {
            
        }
        
        navigationItem.title = "Sipariş Ara"
        
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchPeople()
    }
    
    func searchPeople() {
        
        
        
        let parameters = [
            
            "token": DataManager.userToken,
            "keyword": searchField.text!
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "orders/list/active", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                self.allPeople = [PeopleItem]()
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    print("count \(data.count)")
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let name = data[x]["name"] as! String
                        let address = data[x]["address"] as! String
                        let item = PeopleItem.init(id: id, name: name, address: address)
                        self.allPeople.append(item)
                        
                    }
                    
                    self.loadingView.isHidden = true
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            
        return allPeople.count
            
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleCell
        
        let item = allPeople[indexPath.row]
        
        cell.configureCell(item: item)
        
        return cell
            
         
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       DataManager.selectedOrderId = allPeople[indexPath.row].id
        DataManager.selectedOrder = allPeople[indexPath.row]
        
        if DataManager.isComingFromDemagedProduct {
            performSegue(withIdentifier: "takePhoto", sender: nil)
        } else {
            
        }
        
    }
    
    
    @IBAction func printBarcodePressed(_ sender: Any) {
        
        
        if DataManager.selectedOrderId != nil {
            
            self.loadingView.isHidden = false
            
            
            
            if DataManager.isComingFromDemagedProduct {
                
                
                
            } else {
                
                self.performSegue(withIdentifier: "detail", sender: nil)
                
                let parameters = [
                    
                    "token": DataManager.userToken,
                    "order_id": DataManager.selectedOrderId
                    
                    
                    ] as [String : Any]
                
                fetchData(endpoint: "barcodes/sent/shoes", parameters: parameters as [String : AnyObject]?) { response in
                    
                    
                    
                    if let json = response.object as? Dictionary<String, AnyObject> {
                        
                        print(json)
                        
                        self.loadingView.isHidden = true
                        
                        
                    }
                    
                    
                }
                
            }
            
            
            
        } else {
            
            let alert = UIAlertView()
            alert.message = "Lütfen bir sipariş seçin"
            alert.addButton(withTitle: "Tamam")
            alert.show()
            
        }
        
        
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
