//
//  UIStoryboardExtension.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

extension UIStoryboard {
    //MARK:- Helper storyboard method for initializing UIViewController
   static func initializeControllerFor(_ type: ControllerType) -> UIViewController?{
         let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: type.rawValue)
        return controller
    }
}

enum ControllerType: String {
    case buildChoice = "BuildChoiceViewController"
    case register = "RegisterViewController"
    case colorPicker = "ColorPickerController"
}

