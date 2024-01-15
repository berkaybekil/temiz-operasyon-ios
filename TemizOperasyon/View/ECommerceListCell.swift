//
//  ECommerceListCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 13.06.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit
import Kingfisher

class ECommerceListCell: UITableViewCell {
    
    // Image
    @IBOutlet weak var productImage: UIImageView!
    
    // Labels
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var fourthLbl: UILabel!
    
    // Submit Button
    @IBOutlet weak var submitButton: UIButton!
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: ECommerceListModel) {
        
        firstLbl.text = item.price_name
        secondLbl.text = item.user_name
        thirdLbl.text = "\(item.order_id)"
        fourthLbl.text = item.product_status
        
        firstLbl.adjustsFontSizeToFitWidth = true
        secondLbl.adjustsFontSizeToFitWidth = true
        thirdLbl.adjustsFontSizeToFitWidth = true
        fourthLbl.adjustsFontSizeToFitWidth = true
        
        let url = URL(string: item.image)
        self.productImage.kf.setImage(with: url)
        
    }

}
