//
//  User.swift
//  BakeryOrder
//
//  Created by JaonMicle on 30/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import Foundation
import ObjectMapper

public class User:Mappable{
    
    public var id: Int!
    public var name: String!;
    public var email: String!;
    public var photo: String!
    public var pass: String!;
    public var address: String!;
    public var phone: String!;
    public var location: String!;
    public var user_type: String!; //'user', 'driver', 'bakery'
    public var bakey_id: Int!
    public var subscribe_type: String!
    public var status: String!
    public var evaluation: [String: Int] = [:]
    init(){
        self.id = nil;
        self.name = nil;
        self.email = nil;
        self.photo = nil;
        self.pass = nil;
        self.address = nil;
        self.phone = nil;
        self.location = nil;
        self.bakey_id = nil;
        self.user_type = nil;
        self.subscribe_type = nil;
        self.status = nil;
        self.evaluation = [:];
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.id <- map["_id"]
        self.name <- map["username"]
        self.email <- map["email"]
        self.photo <- map["photo"]
        self.address <- map["address"]
        self.phone <- map["phone"]
        self.location <- map["current_location"]
        self.bakey_id <- map["bakery"]
        self.user_type <- map["user_type"]
        self.subscribe_type <- map["subscribe_type"]
        self.status <- map["status"]
        self.evaluation <- map["evaluation"]
    }
}
