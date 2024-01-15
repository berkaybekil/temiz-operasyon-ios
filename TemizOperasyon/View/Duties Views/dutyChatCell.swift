//
//  dutyChatCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 14.02.2020.
//  Copyright © 2020 Furkan Bekil. All rights reserved.
//

import UIKit

class dutyChatCell: UITableViewCell {
    
    @IBOutlet weak var awayMessageView: UIView!
    @IBOutlet weak var homeMessageView: UIView!
    
    @IBOutlet weak var awayMessageNameLbl: UILabel!
    @IBOutlet weak var awayMessageLblContainerView: UIView!
    @IBOutlet weak var awayMessageLbl: UILabel!
    @IBOutlet weak var awayMessageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var homeMessageNameLbl: UILabel!
    @IBOutlet weak var homeMessageLblContainerView: UIView!
    @IBOutlet weak var homeMessageLbl: UILabel!
    @IBOutlet weak var homeMessageViewHeight: NSLayoutConstraint!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: DutyChatModel) {
        
        let heightOfText = item.message.height(withConstrainedWidth: self.contentView.frame.size.width / 2 - 16, font: UIFont.systemFont(ofSize: 10, weight: .medium))
        awayMessageViewHeight.constant = heightOfText + 16
        homeMessageViewHeight.constant = heightOfText + 16
        
        awayMessageLblContainerView.layer.cornerRadius = 8
        homeMessageLblContainerView.layer.cornerRadius = 8
        
        
        if item.is_me == 1 {
            
            awayMessageView.isHidden = true
            homeMessageView.isHidden = false
            homeMessageLbl.text = item.message
            homeMessageNameLbl.text = "\(item.name) - \(item.date)"
            
        } else {
            
            awayMessageView.isHidden = false
            homeMessageView.isHidden = true
            awayMessageLbl.text = item.message
            awayMessageNameLbl.text = "\(item.name) - \(item.date)"
            
            
        }
        
        
    }
    
    

}


