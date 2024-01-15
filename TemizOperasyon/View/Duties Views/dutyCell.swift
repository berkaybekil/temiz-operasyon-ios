//
//  dutyCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 10.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit

class dutyCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var idAndBarcodeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var isActiveImage: UIImageView!
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: dutyModel) {
        
        nameLbl.text = item.admin_user_name
        spotLbl.text = item.message
        idAndBarcodeLbl.text = "Sipariş: - Barkod: \(item.barcode_number)"
        timeLbl.text = item.due_date
        
        
    }

}
