//
//  Constant.swift
//  shot_doctor
//
//  Created by Admin on 2017/05/06.
//  Copyright © 2017 BenzCruise. All rights reserved.
//

import Foundation

public class Constant{
    private static let PROTOCOL = "http"
    private static let SERVER_ADDR = "server.com"
    
    private static let SERVER_PORT = "xxxx"
    private static let SERVICIES = "service"
    
    
    
    public static let LOGIN_URL = getServerURL() + "user/signin"
    public static let REG_URL = getServerURL() + "user/signup"
    public static let VERICONFIRM_URL = getServerURL() + "user/verifyConfirm";
    public static let VERIFICATION_URL = getServerURL() + "user/verification"
    public static let PROFILEGET_URL = getServerURL() + "user/get"
    public static let PROFILESET_URL = getServerURL() + "user/update"
    public static let FORGOTPASS_URL = getServerURL() + "user/forgotten"
    public static let PROFILESETWITHPHOTO_URL = getServerURL() + "user/updateWithPhoto"
    public static let CHANGEPASS_URL = getServerURL() + "user/update"
    public static let BAKERYORDERSGET_URL = getServerURL() + "order/getMyOrder"
    public static let ORDERCOUNT_URL = getServerURL() + "order/getMyOrderCount"
    public static let BAKERYORDERSTART_URL = getServerURL() + "order/start"
    public static let BAKERYORDERREJECT_URL = getServerURL() + "order/reject"
    public static let DRIVERORDERACCEPT_URL = getServerURL() + "order/accept"
    public static let DRIVERORDERCOMPLETED_URL = getServerURL() + "order/complete"
    public static let BAKERYORDERREPORT_URL = getServerURL() + "order/ready"
    public static let BREADLISTGET_URL = getServerURL() + "bread/get"
    public static let ORDER_URL = getServerURL() + "order/create"
    public static let ORDERVERIFYCONFIRM_URL = getServerURL() + "order/verifyConfirm"
    public static let ORDERHISTORY_URL = getServerURL() + "order/getMyOrder"
    public static let BREADLIKE_URL = getServerURL() + "bread/like"
    public static let BREADUNLIKE_URL = getServerURL() + "bread/unlike"
    public static let DRIVERORDERSGET = getServerURL() + "order/getMyOrder"
    public static let PAYHISTORYGET_URL = getServerURL() + "invoice/get"
    public static let PAYTOKENGET_URL = getServerURL() + "paymentToken"
    public static let PAYMENT_URL = getServerURL() + "order/payment"
    
    public static let LOGIN_VC = "LoginViewController"
    public static let VERIFICATION_VC = "VerificationViewController"
    public static let SWREVEAL_VC = "SWRevealViewController"
    public static let REG_VC = "RegisterViewController"
    public static let PROFILE_VC = "ProfileSettingViewController"
    public static let MENU_VC = "MenuViewController"
    public static let USERORDERBREAD_VC = "UserOrderBreadViewController"
    public static let USERORDER_VC = "UserOrderViewController"
    public static let BAKERYORDERLIST_VC = "BakeryOrderListViewController"
    public static let ORDERVIEW_VC = "OrderViewController"
    public static let DRIVERDELIVERYLIST_VC = "DriverDeliveryListViewController"
    public static let ADDRESSVIEW_VC = "AddressViewController"
    public static let DRIVERORDERDETAILS_VC = "DriverOrderDetailsViewController"
    public static let HISTORY_VC = "UserOrderHistoryViewController"
    public static let PAY_VC = "UserPaymentViewController"
    public static let EVALUTION_VC = "UserEvalutionViewController"
    public static let CONTACT_VC = "UserContactUsViewController"
    public static let ORDERSTATUS_VC = "UserOrderStatusViewController"
    public static let PAYHISTORY_VC = "UserPaymentHistoryViewController"
    
    
    
    
    public static let PRIMARY_COLOR: UIColor = UIColor(red: 120, green: 190, blue: 68)
    public static let SECONDARY_COLOR: UIColor = UIColor(red: 94, green: 94, blue: 94)
    public static let THIRD_COLOR: UIColor = UIColor(red: 217, green: 84, blue: 43)
    
    public static let CURRENCY_UNIT: String = "SAR "
    
    private static func getServerURL()->String{
        return PROTOCOL + "://" + SERVER_ADDR + ":" + SERVER_PORT + "/" + SERVICIES + "/"
    }
}
