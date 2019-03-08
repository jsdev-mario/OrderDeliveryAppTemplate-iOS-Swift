//
//  BakeryOrderViewCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 06/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class BakeryOrderViewCell: UITableViewCell {
    
    @IBOutlet weak var breadImage: UIImageView!
    
    @IBOutlet weak var breadName: UILabel!
    @IBOutlet weak var bread_description: UILabel!
    @IBOutlet weak var bread_count: UITextField!
    
    private var orderItem: OrderItem = OrderItem(){
        didSet{
            self.breadName.text = AppCommon.convertNiltoEmpty(string: orderItem.bread.name, defaultstr: "")
            self.bread_description.text = AppCommon.convertNiltoEmpty(string: orderItem.bread.description, defaultstr: "")
            self.bread_count.text = String(self.orderItem.count);
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
