//
//  Order.swift
//  BakeryOrder
//
//  Created by JaonMicle on 30/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import Foundation
import ObjectMapper

public class Order:Mappable{
    
    public var id: Int!
    public var order_Id: String!
    public var status: String!  // 0: created, 1: started, 2: delivery, 3: payment, 4: completed
    public var client: User!
    public var bakery: Bakery!
    public var time_type: Int = 0 //0: 7-11, 1: 1-4, 2: 7-10
    public var order_date: String!
    public var order_item: [OrderItem] = []
    public var delivery_address: String!
    public var contact_phone: String!;
    public var delivery_location: String!;
    public var total_price: Float = 0.0
    public var driver: User!
    public var message: String!
    public var pay_status: String!
    public var subscrib: Int! = 1;
    public var subscrib_index: Int! = 1;
    public var base_order: Int!
    
    public var paysel_flag: Bool = false;
    
    
    init(){
        self.id = nil;
        self.order_Id = nil;
        self.status = nil;
        self.client = nil;
        self.bakery = nil;
        self.time_type = 0;
        self.total_price = 0.0
        self.order_item = [];
        self.delivery_address = nil;
        self.delivery_location = nil;
        self.contact_phone = nil;
        self.driver = nil;
        self.order_date = nil;
        self.message = nil;
        self.pay_status = nil;
        self.subscrib = 1;
        self.subscrib_index = 1;
        self.base_order = nil;
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.id <- map["_id"]
        if self.id != nil{
            self.order_Id = AppCommon.instance.convertOrder32ID(id: self.id);
        }
        self.status <- map["status"]
        self.client <- map["order_user"]
        self.bakery <- map["order_bakery"]
        self.time_type <- map["time_type"]
        self.order_item <- map["content"]
        self.delivery_address <- map["delivery_address"]
        self.delivery_location <- map["delivery_location"]
        self.contact_phone <- map["contact_phone"]
        self.order_date <- map["createAt"]
        self.driver <- map["order_driver"]
        self.total_price <- map["price"]
        self.message <- map["message"]
        self.pay_status <- map["payment"]
        self.subscrib <- map["subscrib"]
        self.subscrib_index <- map["subscrib_index"]
        self.base_order <- map["base_order"]
        if self.order_date != nil{
            self.order_date = self.order_date.components(separatedBy: "T")[0]
        }
    }
    
    
}
