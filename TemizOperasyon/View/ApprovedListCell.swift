//
//  ApprovedListCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 1.02.2019.
//  Copyright © 2019 Furkan Bekil. All rights reserved.
//

import UIKit
import Kingfisher

class ApprovedListCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var barcodeLbl: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
    }
    
    func configureCell(item: ApprovedListModel) {
        
        nameLbl.text = item.user
        barcodeLbl.text = "\(item.barkod) / \(item.rack)"
        
        mainView.layer.cornerRadius = 4
        removeButton.layer.cornerRadius = 4
        statusButton.layer.cornerRadius = 4
        
        let url = URL(string: item.small_image)
        mainImage.kf.setImage(with: url)
        
        statusButton.setTitle(item.product_status.name, for: .normal)
        
    }

}
