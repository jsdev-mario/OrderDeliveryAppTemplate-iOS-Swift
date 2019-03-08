//
//  UserOrderCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import SDWebImage
class UserOrderCell: UITableViewCell {
    
    @IBOutlet weak var breadImage: UIImageView!
    
    @IBOutlet weak var breadName: UILabel!
    @IBOutlet weak var breadPrice: UITextField!
    @IBOutlet weak var bread_description: UILabel!
    
    @IBOutlet weak var minusBtn: UIButton!
    
    private var orderItem: OrderItem = OrderItem(){
        didSet{
            self.breadName.text = AppCommon.convertNiltoEmpty(string: orderItem.bread.name, defaultstr: "")
            self.breadPrice.text = String(orderItem.bread.price) + Constant.CURRENCY_UNIT + " ✕ " + String(orderItem.count)
            self.bread_description.text = AppCommon.convertNiltoEmpty(string: orderItem.bread.description, defaultstr: "")
            if orderItem.bread.photo != nil{
                if let url = URL(string: orderItem.bread.photo){
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
    
    public func setData(orderitem: OrderItem){
        self.orderItem = orderitem;
    }

}
