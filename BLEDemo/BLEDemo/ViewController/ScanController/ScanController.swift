//
//  ScanController.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanController: UITableViewController {

    var deviceList: [DeviceData] = [DeviceData]()
    var bluetoothConfigurator: BluetoothConfigurator?
    var cachedPeripheralNames = Dictionary<String, String>()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothConfigurator = BluetoothConfigurator(serviceUUID: AppConstants.appUUIDString, delegate: nil)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(ScannedInfoTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.scannedDeviceCellID.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Devices Around"
        //Assigning bluetoothConfigurator delegate to self for getting info
        //related to bluetooth updation
        bluetoothConfigurator?.delegate = self
    }
}

// MARK: - Table view data source
extension ScanController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.scannedDeviceCellID.rawValue, for: indexPath) as? ScannedInfoTableViewCell {
            let device = deviceList[indexPath.row]
            //Taking data from deviceName with device name and color separated with bars
            cell.updateCellFor(deviceInfo: device)
            return cell
        }
        fatalError("Scanned Cell not found")
    }
}

//MARK:- Tableview Delegate Protocol
extension ScanController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceData = deviceList[indexPath.row]
        if let bluetoothConfigurator = bluetoothConfigurator {
            bluetoothConfigurator.selectedDeviceUUID = deviceData.peripheral.identifier
            bluetoothConfigurator.delegate = nil
            
            let controller = ChatMessageController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.bluetoothConfigurator = bluetoothConfigurator
            controller.deviceData = deviceData
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK:- BluetoothConfiguratorDelegate Methods
extension ScanController: BluetoothConfiguratorDelegate {
    func showAlertFor(_ errorString: String) {
        showAlertView("Error", message: errorString)
    }
    
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, with advertisementData: [String : Any]) {
        var peripheralName = cachedPeripheralNames[peripheral.identifier.description] ?? AppConstants.defaultUserName
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = advertisementName
            cachedPeripheralNames[peripheral.identifier.description] = peripheralName
        }
        //Update local list if new device is found
        let userDeviceData = DeviceData(peripheralName, peripheral: peripheral)
        addOrUpdateDeviceListFor(device: userDeviceData)
    }
    
}

private extension ScanController {
    
    /// This Method add device in a list or update existing list with new name
    /// - Parameter device: DeviceData which has to be appended
    func addOrUpdateDeviceListFor(device: DeviceData) {
        //Add device into device list if it don't have with existing idientifier
        if !deviceList.contains(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            deviceList.append(device)
            tableView.reloadData()
        }
        //If device name is currently unknown and the device name has been changed
        //to something else then update the device name in existing list
        else if deviceList.contains(where: {
            $0.peripheral.identifier == device.peripheral.identifier && $0.deviceName == AppConstants.defaultUserName}) && device.deviceName != AppConstants.defaultUserName {
            
            for index in 0..<deviceList.count {
                if (deviceList[index].peripheral.identifier == device.peripheral.identifier) {
                    deviceList[index].deviceName = device.deviceName
                    tableView.reloadData()
                    break
                }
            }
            
        }

    }
}
