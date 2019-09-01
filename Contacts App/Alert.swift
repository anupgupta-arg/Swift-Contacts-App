//
//  Alert.swift
//  Contacts App
//
//  Created by Anup Gupta on 01/09/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import Foundation
import UIKit

extension  UIViewController {
    
    func showErrorAlert(title:String , message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
