//
//  productCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 26.12.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit
import Kingfisher

class productCell: UITableViewCell {
    
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var mainImgButton: UIButton!
    
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
    }
    
    func configureCell(item: ProductModel) {
        
        mainLbl.text = item.name
        
        if item.image != "" {
            
            self.mainImg.isHidden = false
            self.mainImgButton.isHidden = false
            let url = URL(string: item.image)
            mainImg.kf.setImage(with: url)
            
        } else {
            
            self.mainImg.isHidden = true
            self.mainImgButton.isHidden = true
            
        }
        
        mainLbl.sizeToFit()
        
    }

}
