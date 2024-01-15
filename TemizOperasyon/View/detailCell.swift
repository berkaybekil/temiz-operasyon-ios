//
//  detailCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 18.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class detailCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var adminLbl: UILabel!
    @IBOutlet weak var processLbl: UILabel!
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: detailItem) {
        
        dateLbl.text = item.created_at
        dateLbl.sizeToFit()
        
        adminLbl.text = item.admin_name
        adminLbl.sizeToFit()
        
        processLbl.text = item.message
        processLbl.sizeToFit()
        
        
    }

}
