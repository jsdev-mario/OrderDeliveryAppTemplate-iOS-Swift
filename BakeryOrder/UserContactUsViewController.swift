//
//  UserContactUsViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 31/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class UserContactUsViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            self.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 250;
        }
    }
}
