//
//  ErrorCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 19.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit

class ErrorCell: UITableViewCell {
    
    @IBOutlet weak var mainLbl: UILabel!
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }

    func configureCell(text: String) {
        
        mainLbl.text = text
        
    }
    
}
