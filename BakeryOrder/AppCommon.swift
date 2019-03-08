//
//  AppCommon.swift
//  BayleafTakeaway
//
//  Created by Admin on 2017/05/12.
//  Copyright © 2017 BenzCruise. All rights reserved.
//

import Foundation
import UIKit
public class AppCommon{
    
    public static var instance:AppCommon = AppCommon();
    public var user: User! = nil;
    public var orderTimeType: [String] = ["7:00 AM - 11:00 AM", "1:00 PM - 4:00 PM", "7:00PM - 10:00 PM"]
    public var currentOrder: Order! = nil;
    public var currentPayment: Payment! = nil;
    public var breadData: [Bread] = []
    //public var orderHistory: [Order] = [];
    init(){
        self.user = nil;
        self.currentOrder = nil;
        self.currentPayment = nil;
        self.breadData = [];
        //self.orderHistory = [];
    }
    
    public func minusOrderItem(orderitem: OrderItem){
        for i in 0 ..< self.currentOrder.order_item.count{
            if orderitem.bread.id == currentOrder.order_item[i].bread.id{
                self.currentOrder.order_item[i].count = 0
                self.currentOrder.order_item.remove(at: i)
                return;
            }
        }
    }
    
    public func plusOrderItem(orderitem: OrderItem){
        for i in 0 ..< self.currentOrder.order_item.count{
            if orderitem.bread.id == currentOrder.order_item[i].bread.id{
                return;
            }
        }
        self.currentOrder.order_item.append(orderitem);
    }
    
    public func getTotalPrice()->Float{
        if self.currentOrder != nil{
            var totalPrice: Float = 0.0;
            for orderItem in self.currentOrder.order_item{
                totalPrice += orderItem.bread.price * Float(orderItem.count)
            }
            self.currentOrder.total_price = totalPrice
            return totalPrice;
        }
        return 0.0;
    }
    
    public func getBread(id: Int)->Bread!{
        for bread in self.breadData{
            if bread.id == id{
                return bread;
            }
        }
        return nil;
    }
    public func convertOrder32ID(id: Int)->String{
        var id = id;
        let character: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var result = "";
        while id != 0{
            result = character[(id % 36)] + result;
            id = id / 36;
        }
        result = character[id] + result;
        for _ in result.length ..< 5{
            result = "0\(result)"
        }
        return "#\(result)";
    }
}

extension AppCommon{
    public static var  alertController: UIAlertController = UIAlertController();
    public static var isAnimate: Bool = false;
    
    // indicator process.
    public static func startRunProcess(viewController: UIViewController, completion: @escaping ()->Void){
        DispatchQueue.main.async {
            if !isAnimate{
                isAnimate = true;
                alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert);
                let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
                spinnerIndicator.color = UIColor.black
                spinnerIndicator.startAnimating()
                alertController.view.addSubview(spinnerIndicator)
                viewController.present(alertController, animated: false, completion: {
                    completion();
                })
            }
        }
    }
    
    public static func stopRunProcess(){
        DispatchQueue.main.async {
            print("dismiss");
            alertController.dismiss(animated: true, completion: {
                alertController = UIAlertController();
                isAnimate = false;
            });
        }
    }
    
    public static func isInputComplete(_ inputArray: [String:String]) -> String!{
        let keys = Array(inputArray.keys);
        for i in 0 ..< keys.count {
            let key = keys[i] as String;
            if inputArray[key] == ""{
                return keys[i]
            }
        }
        return nil;
    }
    
    public static func filterNull(value: Any?)->String!{
        if value is NSNull || value == nil{
            return nil;
        }
        return value as! String;
    }
    
    public static func convertNiltoEmpty(string: String!, defaultstr: String)->String{
        if string == nil{
            return defaultstr;
        }
        return string;
    }
}


