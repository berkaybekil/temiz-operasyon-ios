//
//  RepairConcentShoeCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 9.04.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit

class RepairConcentShoeCell: UITableViewCell {

    @IBOutlet weak var IDLbl: UILabel!
    @IBOutlet weak var barcodeLbl: UILabel!
    @IBOutlet weak var rackLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var shoeImage: UIImageView!
    
    // Buttons
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var changeStatusButton: UIButton!
    @IBOutlet weak var cleaningButton: UIButton!
    @IBOutlet weak var wetRepairButton: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
    }
    
    func configureCell(item: ShoeModel) {
        
        IDLbl.adjustsFontSizeToFitWidth = true
        barcodeLbl.adjustsFontSizeToFitWidth = true
        rackLbl.adjustsFontSizeToFitWidth = true
        statusLbl.adjustsFontSizeToFitWidth = true
        
        IDLbl.text = "\(item.id)"
        barcodeLbl.text = item.barcode
        rackLbl.text = item.rack
        statusLbl.text = item.product_status
        
        let url = URL(string: item.image)
        shoeImage.kf.setImage(with: url)
        
    }

}
