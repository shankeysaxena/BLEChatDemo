//
//  DeviceData.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation
import CoreBluetooth

struct DeviceData {
    var deviceName: String
    var peripheral: CBPeripheral
    var messages: [ChatMessage] = [ChatMessage]()
    
    init(_ deviceName: String, peripheral: CBPeripheral) {
        self.deviceName = deviceName
        self.peripheral = peripheral
    }
}
