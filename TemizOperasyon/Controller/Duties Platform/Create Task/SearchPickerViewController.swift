//
//  SearchPickerViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit

class SearchPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Page Title
    @IBOutlet weak var pageTitleLbl: UILabel!
    
    
    // Search Area
    @IBOutlet weak var searchArea: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    // Item Arary
    var itemArray = [dutySearchModel]()
    
    // Loading Processor
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.adjustPageTitle()
        
        
        
    }
    
    func adjustPageTitle() {
        
        if DataManager.isComingFromTaskDetail {
            
            if DataManager.selectedDutyForDetail.admin_user_name != "" {
                
                self.pageTitleLbl.text = "Kullanıcı Değiştir"
                DataManager.dutySearchType = "task/get_admin_user_list"
                
            } else {
                
                self.pageTitleLbl.text = "Grup Değiştir"
                DataManager.dutySearchType = "task/get_orders_list"
            }
            
        } else {
            switch DataManager.dutySearchType {
            case "task/get_admin_user_list":
                print("")
                self.pageTitleLbl.text = "Atanacak Kullanıcı Seç"
            case "task/get_groups_list":
                print("")
                self.pageTitleLbl.text = "Grup Seç"
            case "task/get_orders_list":
                print("")
                self.pageTitleLbl.text = "Sipariş Seç"
            case "task/get_barcodes_list":
                print("")
                self.pageTitleLbl.text = "Barkod Seç"
            case "task/get_user_list":
                print("")
                self.pageTitleLbl.text = "Kullanıcı Seç"
            default:
                print("no type found")
            }
        }
        
        self.getJson()
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.getJson()
        
        
    }
    
    func getJson() {
        
        self.loadingIndicator.isHidden = false
        let parameters = [
            
            "token": DataManager.userToken,
            "keyword": searchField.text
            
            
            
            ] as [String : Any]
        
        fetchData(endpoint: DataManager.dutySearchType, parameters: parameters as [String : AnyObject]?) { response in
            
            
            
            if let json = response.object as? Dictionary<String, AnyObject> {
                
                self.itemArray = [dutySearchModel]()
                self.tableView.reloadData()
                self.loadingIndicator.isHidden = true
                
                if let data = json["data"] as? [Dictionary<String, AnyObject>] {
                    
                    for x in 0 ..< data.count {
                        
                        let id = data[x]["id"] as! Int
                        let text = data[x]["text"] as! String
                        
                        let item = dutySearchModel.init(id: id, name: text)
                        self.itemArray.append(item)
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        }
        
    }
    
    // TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dutySearchCell") as! dutySearchCell?
        
        let item = self.itemArray[indexPath.row]
        cell?.configureCell(item: item)
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DataManager.selectedSearchType = self.itemArray[indexPath.row]
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    

    // Actions
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

}
