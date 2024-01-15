//
//  MainButtonCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 25.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import UIKit

protocol mainButtonCellDelegate: class {
    
    func mainButtonPressed(id: Int)
    
}

class MainButtonCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var mainButton: UIButton!
    
    // Protocol
    weak var delegate: mainButtonCellDelegate?
    
    // Current Item
    var currentItem: MainButtonModel!
    
    func populateCell(_ item: MainButtonModel) {
        self.mainButton.layer.cornerRadius = 8
        currentItem = item
        self.mainButton.setTitle(item.text, for: .normal)
        let color = "#\(item.color!)"
        self.mainButton.backgroundColor = UIColor.init(hexString: color)
        
    }
    
    // MARK: IBActions
    
    @IBAction func mainButtonPressed(_ sender: Any) {
        
        delegate?.mainButtonPressed(id: currentItem.id ?? 0)
        
    }
    
}
