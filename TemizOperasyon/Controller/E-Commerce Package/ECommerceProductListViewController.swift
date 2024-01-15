//
//  ECommerceProductListViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 13.06.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit

class ECommerceProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    // Product Array
    var productArray = [ECommerceListModel]()
    
    // Loading View
    @IBOutlet weak var loadingView: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = DataManager.shoeOrderListArea
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getProducts()
        
    }
    
    func getProducts() {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "date": DataManager.shoeOrderListDate,
            "area": DataManager.shoeOrderListArea
           
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "ecommerce/product_list", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                print(json)
                
                self.productArray = [ECommerceListModel]()
                
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let price_id = data[x]["price_id"] as! Int
                        let price_name = data[x]["price_name"] as! String
                        let user_name = data[x]["user_name"] as! String
                        let order_id = data[x]["order_id"] as! Int
                        let image = data[x]["image"] as! String
                        let product_status = data[x]["product_status"] as! String
                        
                        
                        
                        
                        let item = ECommerceListModel.init(id: id, price_id: price_id, price_name: price_name, user_name: user_name, order_id: order_id, image: image, product_status: product_status)
                        self.productArray.append(item)
                        
                        
                    }
                    
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                    
                }
                
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return productArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ECommerceListCell", for: indexPath) as! ECommerceListCell
        
        let item = self.productArray[indexPath.row]
        
        cell.configureCell(item: item)
        
        cell.submitButton.tag = indexPath.row
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        self.loadingView.isHidden = false
        
        let parameters = [
            
            "token": DataManager.userToken,
            "id": self.productArray[sender.tag].id,
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: "ecommerce/set_product_packed", parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                self.loadingView.isHidden = true
                
                if json["errorCode"] as! String == "00" {
                    
                    let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        self.getProducts()
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "", message: json["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
        
    }
    

}
