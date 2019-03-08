//
//  DriverDeliveyCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class DriverDeliveyCell: UITableViewCell {
    
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryNumber: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var stateImage: ExtentionImageView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var deliveriedBtn: UIButton!
    @IBOutlet weak var acceptIcon: UIImageView!
    @IBOutlet weak var deliveryIcon: UIImageView!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var acceptTime: UILabel!
    
    
    public var order: Order = Order(){
        didSet{
            self.userName.text = AppCommon.convertNiltoEmpty(string: order.client.name, defaultstr: "");
            self.userAddress.text = AppCommon.convertNiltoEmpty(string: order.delivery_address, defaultstr: "")
            self.deliveryTime.text = AppCommon.convertNiltoEmpty(string: AppCommon.instance.orderTimeType[order.time_type], defaultstr: "")
            self.deliveryNumber.text =  AppCommon.convertNiltoEmpty(string: order.order_Id, defaultstr: "")
            self.acceptTime.text = AppCommon.convertNiltoEmpty(string: order.message, defaultstr: "")
            if order.client.photo != nil{
                if let url = URL(string: order.client.photo){
                    self.stateImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profilemain"))
                }
            }else{
                self.stateImage.image = nil;
            }
            
            if order.status == "started"{
                self.acceptBtn.setTitleColor(Constant.PRIMARY_COLOR, for: .normal);
                self.acceptIcon.image = #imageLiteral(resourceName: "likeicon-green")
                self.acceptBtn.isUserInteractionEnabled = true;
                self.deliveriedBtn.setTitleColor(Constant.SECONDARY_COLOR, for: .normal);
                self.deliveryIcon.image = #imageLiteral(resourceName: "addressicon-gray")
                self.deliveriedBtn.isUserInteractionEnabled = false;
            }else if order.status == "accepted" || order.status == "delivery"{
                self.acceptBtn.setTitleColor(Constant.SECONDARY_COLOR, for: .normal);
                self.acceptIcon.image = #imageLiteral(resourceName: "likeicon-gray")
                self.acceptBtn.isUserInteractionEnabled = false;
                self.deliveriedBtn.setTitleColor(Constant.PRIMARY_COLOR, for: .normal);
                self.deliveryIcon.image = #imageLiteral(resourceName: "addressicon-green")
                self.deliveriedBtn.isUserInteractionEnabled = true;
            }else{
                self.acceptBtn.setTitleColor(Constant.SECONDARY_COLOR, for: .normal);
                self.acceptIcon.image = #imageLiteral(resourceName: "likeicon-gray")
                self.acceptBtn.isUserInteractionEnabled = false;
                self.deliveriedBtn.setTitleColor(Constant.SECONDARY_COLOR, for: .normal);
                self.deliveryIcon.image = #imageLiteral(resourceName: "addressicon-gray")
                self.deliveriedBtn.isUserInteractionEnabled = false;
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

}
