//
//  Bakery.swift
//  BakeryOrder
//
//  Created by JaonMicle on 30/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import Foundation
import ObjectMapper

public class Bakery:Mappable{
    
    public var id: Int!
    public var name: String!;
    public var photo: String!
    public var description: String!
    public var address: String!;
    public var phone: String!;
    public var location: String!;
    
    init(){
        self.id = nil;
        self.name = nil;
        self.photo = nil;
        self.description = nil;
        self.address = nil;
        self.phone = nil;
        self.location = nil;
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.id <- map["_id"]
        self.name <- map["name"]
        self.photo <- map["photo"]
        self.description <- map["description"]
        self.address <- map["address"]
        self.phone <- map["phone"]
        self.location <- map["location"]
    }
}
