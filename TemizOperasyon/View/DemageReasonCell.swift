//
//  DemageReasonCell.swift
//  TemizOperasyon
//
//  Created by Furkan Bekil on 11.10.2018.
//  Copyright © 2018 Furkan Bekil. All rights reserved.
//

import UIKit

class DemageReasonCell: UITableViewCell {

    // Main Label
    @IBOutlet weak var mainLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        
        
    }
    
    func configureCell(item: DemageReasonModel) {
        
       mainLbl.text = item.reason
        
    }
    
    func configureCellForStoreQr(Text: String){
        
        self.mainLbl.text = Text
        
    }

}
