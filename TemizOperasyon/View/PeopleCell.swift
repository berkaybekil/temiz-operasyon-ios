//
//  PeopleCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 19.04.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {

    @IBOutlet weak var peopleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: PeopleItem) {
        
        peopleLbl.text = item.name
        addressLbl.text = item.address
        orderIdLbl.text = "Sipariş ID: \(item.id)"
        
    }

}
