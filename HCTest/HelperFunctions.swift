//
//  HelperFunctions.swift
//  HCTest
//
//  Created by 이채원 on 2018. 5. 29..
//  Copyright © 2018년 david. All rights reserved.
//

import UIKit

func presentAlert(target: UIViewController, title: String? = nil, message: String? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "ok", style: .default, handler: nil)
    
    alertController.addAction(action)
    
    target.present(alertController, animated: true, completion: nil)
}
