//
//  Constant.swift
//  BLEDemo
//
//  Created by apple on 7/29/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit
import CoreBluetooth

enum BuildOptionsTag: Int {
    case sender = 101
    case receiver = 102
}

struct ErrorMessage {
    static let connectionResettingMessage = "The connection with the system service was momentarily lost, update imminent."
    static let platformUnsupportedMessage = "The platform doesn't support Bluetooth Low Energy."
    static let connectionAuthorizationMessage = "The app is not authorized to use Bluetooth Low Energy. Please give appropriate permissions from Settings."
    static let bluetoothPoweredOffMessage = "Please switch on bluetooth."
    static let bluetoothStateUnkwonMessage = "Not able to collaborate with bluetooth. Please try again after sometime."
}

enum CellIdentifiers: String {
    case chatMessagesCellID = "chatMessagesCellID"
    case colorPickerCellID = "colorPickerCellID"
    case scannedDeviceCellID = "scannedDeviceCellID"
}

struct AppConstants {
    static let defaultUserName = "Unknown (App not installed)"
    static let userInfoKey = "userInfoKey"
    static let appUUIDString = "806F7A9D-4153-4E75-B500-998CE7715EF6"
    static let collectionViewBottomSpace = 58
    static let colorsForDevices: [UIColor] = [.red, .purple, .green, .blue, .orange, .magenta, .black]
}
