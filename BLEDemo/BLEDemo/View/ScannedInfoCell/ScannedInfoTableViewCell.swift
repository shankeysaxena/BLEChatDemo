//
//  ScannedInfoTableViewCell.swift
//  BLEDemo
//
//  Created by apple on 7/31/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class ScannedInfoTableViewCell: UITableViewCell {
    
    let heightWidthConstant = 50
    //Rounded colored view
    let coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //Device name label
    let deviceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(coloredView)
        addSubview(deviceNameLabel)
        configureColoredView()
        configureLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deviceNameLabel.text = ""
        coloredView.backgroundColor = .gray
    }
    
    /// Update UI with device info
    /// - Parameter deviceInfo: DeviceData Object through which label and color will be updated
    func updateCellFor(deviceInfo: DeviceData) {
        coloredView.layer.cornerRadius = coloredView.frame.size.width/2
        coloredView.clipsToBounds = true
        let advertisementData = deviceInfo.deviceName.components(separatedBy: "|")
        deviceNameLabel.text = advertisementData[0]
        if advertisementData.count > 1 {
            coloredView.backgroundColor = AppConstants.colorsForDevices[Int(advertisementData[1])!]
        }
    }
}

//MARK:- Private extension for configuring UI elements
private extension ScannedInfoTableViewCell {
    
    func configureColoredView() {
        coloredView.heightAnchor.constraint(equalToConstant: CGFloat(heightWidthConstant)).isActive = true
        coloredView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        coloredView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        coloredView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        coloredView.widthAnchor.constraint(equalToConstant: CGFloat(heightWidthConstant)).isActive = true
        deviceNameLabel.leftAnchor.constraint(equalTo: coloredView.rightAnchor, constant: 8).isActive = true
    }
    
    func configureLabel() {
        deviceNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        deviceNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        deviceNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}
