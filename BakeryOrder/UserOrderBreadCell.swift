//
//  UserOrderBreadCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import SDWebImage

class UserOrderBreadCell: UITableViewCell {
    
    @IBOutlet weak var breadName: UILabel!
    @IBOutlet weak var breadPrice: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var numberText: UILabel!
    @IBOutlet weak var breadImage: UIImageView!
    @IBOutlet weak var spbreadImage: UIImageView!
    @IBOutlet weak var likecount: UILabel!
    @IBOutlet weak var unlikecount: UILabel!
    @IBOutlet weak var spBtn: UIButton!
    @IBOutlet weak var spConfirmIcon: UIImageView!
    @IBOutlet weak var spView: UIView!
    

    private var orderItem: OrderItem = OrderItem(){
        didSet{
            self.breadName.text = AppCommon.convertNiltoEmpty(string: self.orderItem.bread.name, defaultstr: "")
            //self.breadPrice.text = Constant.CURRENCY_UNIT + String(self.orderItem.bread.price)
            self.breadPrice.text = "\(String(self.orderItem.bread.price)) \(Constant.CURRENCY_UNIT)"
            self.likecount.text = AppCommon.convertNiltoEmpty(string: String(self.orderItem.bread.like_count), defaultstr: "")
            self.unlikecount.text = AppCommon.convertNiltoEmpty(string: String(self.orderItem.bread.unlike_count), defaultstr: "")
            self.numberText.text = AppCommon.convertNiltoEmpty(string: String(self.orderItem.count), defaultstr: "")
            if self.numberText.text != "0"{
                self.numberText.textColor = UIColor.red
            }else{
                self.numberText.textColor = Constant.SECONDARY_COLOR
            }
            if self.orderItem.bread.photo != nil{
                if let url = URL(string: self.orderItem.bread.photo){
                    self.breadImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "breadplaceholder"))
                }
            }
            if self.orderItem.sp_offer{
                self.spConfirmIcon.image = #imageLiteral(resourceName: "confirmicon-green")
            }else{
                self.spConfirmIcon.image = nil;
            }
            
            
            if self.orderItem.bread.sp_bread != nil{
                self.spView.isHidden = false;
                if self.orderItem.bread.sp_bread.photo != nil{
                    if let url = URL(string: self.orderItem.bread.sp_bread.photo){
                        self.spbreadImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "breadplaceholder"))
                        print("sp_bread: \(url)")
                    }
                }
            }else{
                print("sp_bread nil");
                self.spView.isHidden = true;
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
    
    public func setBread(breadData: OrderItem){
        self.orderItem = breadData
    }
}
