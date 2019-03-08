//
//  UserPaymentViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 31/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON
import Toaster


class UserPaymentViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBOutlet weak var payPriceLabel: UILabel!
    
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var acceptCreditCards: Bool = true{
        didSet{
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    var payPalConfig = PayPalConfiguration() // default
    
    public var parentVc: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.payPriceLabel.text = "\(AppCommon.instance.currentPayment.pay_price!) \(Constant.CURRENCY_UNIT) \r\n (\(round(Double(AppCommon.instance.currentPayment.pay_price / 3.75), toNearest: 0.01))) USD";
        self.setDismissKeyboard();
        self.paypalInit();
    }
    
    public func paypalInit(){
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Bakery order." //company name
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both
    }

    public func back(){
        self.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                if self.parentVc != nil{
                    if let vc = self.parentVc as? UserOrderViewController{
                        vc.dismiss(animated: true, completion: {
                            DispatchQueue.main.async {
                                vc.dismiss()
                                return;
                            }
                        })
                    }
                }
            }
        })
    }
    
    @IBAction func cashAction(_ sender: UIButton) {
        self.back()
    }
    
    @IBAction func payAction(_ sender: UIButton) {
        if AppCommon.instance.currentPayment.pay_price == 0.0{
            Toast(text: "Can't payment. Price error.").show()
            return;
        }
        
//        let item1 = PayPalItem(name: "bread order", withQuantity: 1, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
        
        let totalFloat = round(Double(AppCommon.instance.currentPayment.pay_price / 3.75), toNearest: 0.01)
        let str = String(format: "%.2f", totalFloat);
        let total = NSDecimalNumber(string: str)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "BakeryOrder", intent: .sale)
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }else {
            print("Payment not processalbe: \(payment)")
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.back()
        
    }
    
    
    
    public func sendPayToServer(amount: Float, pay_method: String){
        let param: [String: Any] = ["orders": AppCommon.instance.currentPayment.pay_orderids, "amount": String(AppCommon.instance.currentPayment.pay_price!), "payment_method": pay_method]
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.PAYMENT_URL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        Toast(text: "Payment Success.").show();
                        DispatchQueue.main.async {
                           self.back();
                        }
                    }else{
                        Toast(text: jsonData["Please check payment account."].stringValue).show();
                    }
                    break;
                case .failure( _):
                    Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                    break;
                }
            })
        })
    }
}


extension UserPaymentViewController: PayPalPaymentDelegate{
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        self.sendPayToServer(amount:Float(self.payPriceLabel.text!)! , pay_method: "paypal")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            print(completedPayment.description)
        })
    }
}

