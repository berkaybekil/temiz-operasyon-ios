//
//  RepairNotesCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 11.05.2021.
//  Copyright © 2021 Furkan Bekil. All rights reserved.
//

import UIKit

protocol RepairNotesCellProtocol: class {
    
    func printButtonPressed(id: Int)
    
}

class RepairNotesCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Cell Protocol
    weak var cellProtocol: RepairNotesCellProtocol?
    
    // Current Item
    var currentItem: CustomerModel!
    
    func populateCell(item: CustomerModel) {
        
        self.IDLabel.text = "\(item.id)"
        self.nameLabel.text = item.name
        self.statusLabel.text = item.status
        self.dateLabel.text = item.pickup_date
        
        self.currentItem = item
        
    }

    @IBAction func printButtonPressed(_ sender: Any) {
        
        cellProtocol?.printButtonPressed(id: self.currentItem.id)
        
    }
    
}
