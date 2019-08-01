//
//  UserData.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation

struct UserData {
    
    var deviceName: String = AppConstants.defaultUserName
    var colorCode: Int = 0
    
    public init(){
        if let dictionary = UserDefaults.standard.dictionary(forKey: AppConstants.userInfoKey) {
            deviceName = dictionary["name"] as? String ?? ""
            colorCode = dictionary["colorCode"] as? Int ?? 0
        }
    }
    
    public func save() {
        var dictionary : Dictionary = Dictionary<String, Any>()
        dictionary["name"] = deviceName
        dictionary["colorCode"] = colorCode
        
        UserDefaults.standard.set(dictionary, forKey: AppConstants.userInfoKey)
    }
    
}
