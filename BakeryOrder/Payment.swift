//
//  PaymentItem.swift
//  BakeryOrder
//
//  Created by JaonMicle on 05/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import Foundation
import ObjectMapper
public class Payment: Mappable{
    
    public var id: Int!
    public var pay_user: User!
    public var pay_date: String!
    public var pay_price: Float!
    public var pay_orderids: [Int] = []
    public var pay_type: String!
    
    init(){
        self.pay_date = nil;
        self.pay_user = nil;
        self.pay_price = nil;
        self.pay_orderids = []
        self.pay_type = "paypal"
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.id <- map["_id"]
        self.pay_price <- map["amount"]
        self.pay_date <- map["date"]
        self.pay_user <- map["user"]
        self.pay_orderids <- map["orders"]
        self.pay_type <- map["payment_method"]
    }
}
