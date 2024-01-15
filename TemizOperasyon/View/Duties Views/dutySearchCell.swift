//
//  dutySearchCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit

class dutySearchCell: UITableViewCell {
    
    @IBOutlet weak var mainLbl: UILabel!
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: dutySearchModel) {
        
        mainLbl.text = item.name
        
        
    }

}
