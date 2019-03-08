//
//  Evalution.swift
//  BakeryOrder
//
//  Created by JaonMicle on 03/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import Foundation
import ObjectMapper


public class Evaluation: Mappable{
    public var bread: Bread!
    public var like: Int = 0
    init(){
        self.bread = nil;
        self.like = 0;
    }
    
    init(bread: Bread, like: Int){
        self.bread = bread;
        self.like = like;
    }
    
    public required init?(map: Map) {
        
    }

    
    public func mapping(map: Map) {
        self.bread <- map["bread"]
        self.like <- map["like"]
    }
    
    
}
