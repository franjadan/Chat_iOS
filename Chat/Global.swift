//
//  Global.swift
//  Chat
//
//  Created by francisco.adan on 23/01/2020.
//  Copyright © 2020 francisco.adan. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

struct AppData {
    static let contacts: [String: String] = [
        "Raul": "f81a5415e5cbbf525b2163039ca6edc711f20c08eb7a48deb93350d932b11195",
        "Fran": "e3480807cafcf6eb6286adf22054d26a708add7f832c8d95745892b60d217a17"
    ];
    
    static var activeChat: String = ""
    
    static var messages: [String: [(String, String)]] = [
        "Raul": [],
        "Fran": []
    ];
}
