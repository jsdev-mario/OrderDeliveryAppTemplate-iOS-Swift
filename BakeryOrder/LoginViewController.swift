//
//  ViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 27/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON
import Toaster
import SCLAlertView

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameText: HoshiTextField!
    @IBOutlet weak var passwordText: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDismissKeyboard();
        self.initData();
    }
    
    public func initData(){
        if UserDefaults.standard.object(forKey: "name") != nil{
            if let name = UserDefaults.standard.object(forKey: "name") as? String{
                self.usernameText.text = name;
            }
        }
        
        if UserDefaults.standard.object(forKey: "password") != nil{
            if let pass = UserDefaults.standard.object(forKey: "password") as? String{
                self.passwordText.text = pass;
            }
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton){
        if self.usernameText.text == ""{
            Toast(text: NSLocalizedString("Please enter username or phone number.", comment: "")).show();
            return;
        }
        
        if self.passwordText.text == ""{
            Toast(text: NSLocalizedString("Please enter password.", comment: "")).show();
            return;
        }
        
        let param: [String: Any] = ["user": self.usernameText.text!.lowercased(), "password": self.passwordText.text!]
        
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.LOGIN_URL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        AppCommon.instance.user = User(JSONString: jsonData["data"].rawString()!)
                        AppCommon.instance.user.pass = self.passwordText.text;
                        if AppCommon.instance.user.status == "inactive"{
                            self.go(to: Constant.VERIFICATION_VC, param: nil)
                        }else{
                            self.goHome();
                        }
                    }else if jsonData["code"].intValue == 3{
                        Toast(text: NSLocalizedString("Account was deleted by Admin.", comment: "")).show();
                    }else if jsonData["code"].intValue == 4{
                        Toast(text: NSLocalizedString("Security info is incorrect.", comment: "")).show();
                    }else if jsonData["code"].intValue == 5{
                        Toast(text: NSLocalizedString("Account not exists.", comment: "")).show();
                    }else{
                        Toast(text:NSLocalizedString("Failure.", comment: "")).show();
                    }
                    break;
                case .failure(let error):
                    print(error.localizedDescription)
                    Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                    break;
                }
            }
        })
        self.goHome()
        UserDefaults.standard.set(self.usernameText.text!, forKey: "name");
        UserDefaults.standard.set(self.passwordText.text!, forKey: "password");
    }
    
    public func goHome(){
        DispatchQueue.main.async {
            if AppCommon.instance.user != nil{
                if AppCommon.instance.user.user_type == "user"{
                    self.go(to: Constant.SWREVEAL_VC, param: nil)
                }else if AppCommon.instance.user.user_type == "bakery"{
                    self.go(to: Constant.BAKERYORDERLIST_VC, param: nil)
                }else if AppCommon.instance.user.user_type == "driver"{
                    self.go(to: Constant.DRIVERDELIVERYLIST_VC, param: nil)
                }
            }
        }
    }
    
    @IBAction func forgotAction(_ sender: UIButton) {
        let alert = SCLAlertView()
        let phone = alert.addTextField(NSLocalizedString("Please enter phone number.", comment: ""))
        phone.keyboardType = .phonePad
        alert.addButton(NSLocalizedString("Send", comment: "")) {
            if phone.text == ""{
                Toast(text: NSLocalizedString("Invalidate phone number.", comment: "")).show();
            }
            self.sendForgotPass(phone: phone.text!)
        }
        alert.showEdit(NSLocalizedString("Forgot Password", comment: ""), subTitle: "", closeButtonTitle: NSLocalizedString("Cancel", comment: ""), colorStyle: 0x78BE44)
    }
    
    public func sendForgotPass(phone: String){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.FORGOTPASS_URL, method: .post, parameters: [phone: phone], encoding: JSONEncoding.default).responseJSON { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        Toast(text: NSLocalizedString("Success.", comment: "")).show();
                    }else{
                        Toast(text: NSLocalizedString("Failure.", comment: "")).show();
                    }
                    break;
                case .failure(let error):
                    Toast(text: error.localizedDescription).show();
                    break;
                }
            }
        })
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        self.go(to: Constant.REG_VC, param: nil)
    }
    
    public func go(to: String, param: Any!){
        DispatchQueue.main.async {
            if to == Constant.REG_VC{
                let toVc: RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! RegisterViewController;
                self.present(toVc, animated: true, completion: nil)
            }else if to == Constant.SWREVEAL_VC{
                let toVc: SWRevealViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! SWRevealViewController;
                self.present(toVc, animated: true, completion: nil)
            }else if to == Constant.BAKERYORDERLIST_VC{
                let toVc: BakeryOrderListViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! BakeryOrderListViewController;
                self.present(toVc, animated: true, completion: nil)
            }else if to == Constant.DRIVERDELIVERYLIST_VC{
                let toVc: DriverDeliveryListViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! DriverDeliveryListViewController;
                self.present(toVc, animated: true, completion: nil)
            }else if to == Constant.VERIFICATION_VC{
                let toVc: VerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! VerificationViewController;
                self.present(toVc, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

