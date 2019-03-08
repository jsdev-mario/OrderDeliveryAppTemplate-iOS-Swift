//
//  UserSpOrderCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 04/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class UserSpOrderCell: UITableViewCell {

    @IBOutlet weak var breadImage: UIImageView!
    
    @IBOutlet weak var breadName: UILabel!
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var bread_description: UILabel!
    
    private var bread: Bread = Bread(){
        didSet{
            self.breadName.text = AppCommon.convertNiltoEmpty(string: bread.name, defaultstr: "")
            if bread.photo != nil{
                if let url = URL(string: bread.photo){
                    self.breadImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "breadplaceholder"))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setData(spoffer: SpecOffer){
        self.bread = spoffer.bread;
    }

}
