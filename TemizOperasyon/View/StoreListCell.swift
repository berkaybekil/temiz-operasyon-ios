//
//  StoreListCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 24.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit

class StoreListCell: UITableViewCell {

    // Main Lbl
    @IBOutlet weak var mainLbl: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(text: String) {
        
        mainLbl.text = text
        
    }

}
