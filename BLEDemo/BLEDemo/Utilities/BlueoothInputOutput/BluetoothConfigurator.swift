//
//  BluetoothConfigurator.swift
//  BLEDemo
//
//  Created by apple on 7/29/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

//MARK:- BluetoothConfigurator Protocol
protocol BluetoothConfiguratorDelegate: class {
    func showAlertFor(_ errorString: String)
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, with advertisementData: [String: Any])
    func writeValueWith(_ closure: (String) -> Void)
    func messageReceiveWith(_ data: Data?)
}
//MARK:- BluetoothConfigurator Protocol Extension
extension BluetoothConfiguratorDelegate {
    func writeValueWith(_ closure: (String) -> Void) {}
    func messageReceiveWith(_ data: Data?){}
}

final class BluetoothConfigurator: NSObject {
    //MARK:- Private variables
    //Characteristics and services properties and permissions through which
    //central will write values to peripherals
    private let READ_WRITE_PROPERTIES: CBCharacteristicProperties = .write
    private let READ_WRITE_PERMISSIONS: CBAttributePermissions = .writeable
    //Random UUID generated through "uuidgen" command through terminal
    private let READ_WRITE_UUID = "4235621F-6D5C-4639-9131-7D4BE059A128"
    //Service UUID through which we will access all the services
    private let serviceUUID: String
    //Selected peripheral once user will select the peripheral
    //through which he/she wants to initiate a service (In this case, chat)
    private var selectedPeripheral: CBPeripheral?
    // Cantral Manager and Peripheral manager local variables to access services
    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    // BluetoothConfiguratorDelegate variable to respond back to registered objects
    weak var delegate: BluetoothConfiguratorDelegate?
    //Selected UUID
    var selectedDeviceUUID: UUID?

    //MARK:- Public methods
    /// Custom Initialisation method for initialising service through bluetooth
    /// - Parameters:
    ///   - serviceUUID: service UUID generated through uuidgen command on terminal
    ///   - delegate: BluetoothConfiguratorDelegate object through which the calling object
    /// is registered
    init(serviceUUID: String, delegate: BluetoothConfiguratorDelegate?) {
        self.serviceUUID = serviceUUID
        self.delegate = delegate
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    /// Method for connecting the central device to selected peripheral for sending message
    func connectDeviceForSendingMessage() {
        centralManager?.connect(selectedPeripheral!, options: nil)
    }
    
}

//MARK:- CBCentralManagerDelegate Methods
extension BluetoothConfigurator: CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let delegate = delegate else {
            return
        }
        //If delegate is not of type ScanController, then assign delegate to self
        if !(delegate is ScanController) {
            peripheral.delegate = self
        }
        //Discovering service UUID specific to our app
        peripheral.discoverServices([CBUUID(string: serviceUUID)])
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Here we can read peripheral.identifier as UUID, and read our advertisement data by the key CBAdvertisementDataLocalNameKey
        guard let delegate = delegate else {
            return
        }
        if delegate is ScanController {
            delegate.didDiscoverPeripheral(peripheral, with: advertisementData)
        } else {
            //Assigning peripheral to selectedPeripheral if device identifier is same as
            //of selected device device UUID
            if (peripheral.identifier == selectedDeviceUUID) {
                selectedPeripheral = peripheral
            }
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard let delegate = delegate, ((delegate as? UIViewController) != nil) else {
            return
        }
        
        switch central.state {
        case .resetting:
            delegate.showAlertFor(ErrorMessage.connectionResettingMessage)
        case .unsupported:
             delegate.showAlertFor(ErrorMessage.platformUnsupportedMessage)
        case .unauthorized:
             delegate.showAlertFor(ErrorMessage.connectionAuthorizationMessage)
        case .poweredOff:
             delegate.showAlertFor(ErrorMessage.bluetoothPoweredOffMessage)
        case .poweredOn:
            scanPeripheralsForClient()
        case .unknown:
            fallthrough
        @unknown default:
            delegate.showAlertFor(ErrorMessage.bluetoothStateUnkwonMessage)
        }
    }
}

//MARK:- CBPeripheralManagerDelegate Methods
extension BluetoothConfigurator: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard let delegate = delegate else {
            return
        }
        
        //If delegate is of type ScanController, perform following function
        if delegate is ScanController {
            performSetupForScanWith(peripheral: peripheral)
        } else {
            //Else initialise service on peripheral manager object
            performSetupForServicesOnPeripheralManager()
            //Start advertising again
            startAdvertisingDataOfPeripheral()
        }
    }
}

//MARK:- CBPeripheralDelegate Methods
extension BluetoothConfigurator: CBPeripheralDelegate {
    func peripheral( _ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([CBUUID(string: READ_WRITE_UUID)], for: service)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        guard let delegate = delegate, !(delegate is ScanController) else {
            return
        }
        
        for request in requests {
            if let value = request.value {
                delegate.messageReceiveWith(value)
            }
            //Responding back to client for conforming receipt of each message
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let delegate = delegate else {
            return
        }
        for characteristic in service.characteristics! {
            let characteristic = characteristic as CBCharacteristic
            if (characteristic.uuid.isEqual(CBUUID(string: READ_WRITE_UUID))) {
                delegate.writeValueWith { (message) in
                    //Sending message by writing data with pre defined characteristics
                    let data = message.data(using: .utf8)
                    peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                }
            }
            
        }
    }
}

//MARK:- Private methods
private extension BluetoothConfigurator {
    
    func performSetupForScanWith(peripheral: CBPeripheralManager) {
        guard let delegate = delegate else {
            return
        }
        
        switch peripheral.state {
        case .resetting:
            delegate.showAlertFor(ErrorMessage.connectionResettingMessage)
        case .unsupported:
            delegate.showAlertFor(ErrorMessage.platformUnsupportedMessage)
        case .unauthorized:
            delegate.showAlertFor(ErrorMessage.connectionAuthorizationMessage)
        case .poweredOff:
            delegate.showAlertFor(ErrorMessage.bluetoothPoweredOffMessage)
        case .poweredOn:
            startAdvertisingDataOfPeripheral()
        case .unknown:
            fallthrough
        @unknown default:
            delegate.showAlertFor(ErrorMessage.bluetoothStateUnkwonMessage)
        }
    }
    
    func performSetupForServicesOnPeripheralManager() {
        /*
         Before starting for advertisement, we initialize the service and characteristics of the peripheral in order to write values from central to peripheral
         */
        let serialService = CBMutableService(type: CBUUID(string: serviceUUID), primary: true)
        let serviceCharacteristic = CBMutableCharacteristic(type: CBUUID(string: READ_WRITE_UUID), properties: READ_WRITE_PROPERTIES, value: nil, permissions: READ_WRITE_PERMISSIONS)
        serialService.characteristics = [serviceCharacteristic]
        peripheralManager.add(serialService)
    }
    
    func scanPeripheralsForClient() {
        //Scanning for devices with UDID specific to our app and ignoring all others
        centralManager.scanForPeripherals(withServices: [CBUUID(string: serviceUUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    //Method for advertising data to the clients with user Info
    func startAdvertisingDataOfPeripheral() {
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        let userData = UserData()
        let advertisementData = String(format: "%@|%d", userData.deviceName, userData.colorCode)
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[CBUUID(string: serviceUUID)], CBAdvertisementDataLocalNameKey: advertisementData])
    }
}
