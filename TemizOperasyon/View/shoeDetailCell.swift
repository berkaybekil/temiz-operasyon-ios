//
//  shoeDetailCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import Kingfisher

class shoeDetailCell: UITableViewCell {

    @IBOutlet weak var shoeImage: UIImageView!
    @IBOutlet weak var barcodeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    // Buttons
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
    }
    
    func configureCell(item: ShoeDetailModel) {
        
        barcodeLbl.adjustsFontSizeToFitWidth = true
        statusLbl.adjustsFontSizeToFitWidth = true
        
        barcodeLbl.text = item.barcode
        statusLbl.text = item.product_status
        
        let url = URL(string: item.image)
        shoeImage.kf.setImage(with: url)
        
        if item.is_control == 1 {
            
            self.contentView.alpha = 1.0
            
        } else {
            
            self.contentView.alpha = 0.5
            
        }
        
    }

}
