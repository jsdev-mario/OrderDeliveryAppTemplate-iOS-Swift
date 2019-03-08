//
//  Bread.swift
//  BakeryOrder
//
//  Created by JaonMicle on 30/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//


import Foundation
import ObjectMapper

public class Bread:Mappable{
    
    public var id: Int!
    public var name: String!;
    public var photo: String!
    public var price: Float = 0.0
    public var description: String!
    public var like_count: Int = 0;
    public var unlike_count: Int = 0;
    public var sp_bread: Bread!
    public var sp_breadid: Int!;
    
    
    init(){
        self.id = nil;
        self.name = nil;
        self.photo = nil;
        self.price = 0.0;
        self.description = nil;
        self.like_count = 0;
        self.unlike_count = 0;
        self.sp_bread = nil;
        self.sp_breadid = nil;
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.id <- map["_id"]
        self.name <- map["name"]
        self.photo <- map["photo"]
        self.price <- map["price"]
        self.description <- map["description"]
        self.like_count <- map["like_count"]
        self.unlike_count <- map["unlike_count"]
        self.sp_bread <- map["sp_bread"]
        self.sp_breadid <- map["sp_bread"]
    }
}
