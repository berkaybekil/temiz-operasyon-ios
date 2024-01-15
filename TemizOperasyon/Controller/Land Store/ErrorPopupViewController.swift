//
//  ErrorPopupViewController.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 19.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit

class ErrorPopupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Okey Button
    @IBOutlet weak var okeyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        adjustViews()
        
    }
    
    func adjustViews() {
        
        self.tableView.layer.cornerRadius = 10
        
        
    }
    
    // Table View Delegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.allErrorArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45)
        view.backgroundColor = UIColor(rgb: 0x00AB66)
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 45))
        if section == 0 {
            label.text = "Kuru Temizleme"
        } else {
            label.text = "Lostra"
        }
        
        self.view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.textColor = UIColor.white
        
        
        view.addSubview(label)
        
        return view
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.allErrorArray[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath) as! ErrorCell
        
        let item = DataManager.allErrorArray[indexPath.section][indexPath.row]
        
        cell.configureCell(text: item)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }

    // Actions
    
    @IBAction func okeyPressed(_ sender: Any) {
        
        DataManager.shoeErrorArray = [String]()
        DataManager.dryCleaningErrorArray = [String]()
        DataManager.allErrorArray = [[String]]()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

}
