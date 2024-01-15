//
//  customerCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 24.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class customerCell: UITableViewCell {

    // Labels
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var IDLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: CustomerModel) {
        
        nameLbl.text = item.name
        statusLbl.text = item.status
        
        IDLbl.text = "\(item.id)"
        hourLbl.text = item.delivery_date
        
    }

}
