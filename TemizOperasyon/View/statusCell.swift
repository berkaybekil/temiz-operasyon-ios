//
//  statusCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 19.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class statusCell: UITableViewCell {
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: statusItem) {
        
        statusLbl.text = item.name
        
    }

}
