//
//  OrderItem.swift
//  BakeryOrder
//
//  Created by JaonMicle on 30/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import Foundation
import ObjectMapper

public class OrderItem:Mappable{
    
    public var bread: Bread!;
    public var count: Int = 0
    public var sp_offer: Bool = false;
    
    
    
    init(){
        self.bread = nil;
        self.count = 0;
        self.sp_offer = false;
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.bread <- map["bread"]
        self.count <- map["count"]
        self.sp_offer <- map["sp_offer"]
    }
}
