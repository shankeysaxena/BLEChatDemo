//
//  UIViewController+Alert.swift
//  BLEDemo
//
//  Created by apple on 7/29/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

extension UIViewController {
    //MARK:- Helper methods for showing alert on UIViewController
    func showAlertView(_ title: String?, message: String?, cancelButtonTitle: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertAction = UIAlertAction.init(title: cancelButtonTitle, style: .default, handler: handler)
        showAlert(actions: [alertAction], title: title, message: message)
    }

    func showAlertView(_ title: String?, message: String?, cancelButtonTitle: String, otherButtonTitle: String, cancelHandler: ((UIAlertAction) -> Void)? = nil, otherOptionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertAction = UIAlertAction.init(title: otherButtonTitle, style: .default, handler: otherOptionHandler)
        let cancelAction = UIAlertAction.init(title: cancelButtonTitle, style: .default, handler: cancelHandler)
        showAlert(actions: [cancelAction, alertAction], title: title, message: message)
    }
    
    func showAlert(actions: [UIAlertAction], title: String? = nil, message: String? = nil, type: UIAlertController.Style = .alert) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: type)
        actions.forEach { alertController.addAction($0) }
        alertController.preferredAction = actions.last
        self.present(alertController, animated: true, completion: nil)
    }
}

