//
//  RegisterViewController.swift
//  BLEDemo
//
//  Created by apple on 7/29/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var colorSelectionButton: UIButton!
    
    private var colorCode: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorSelectionButton.layer.cornerRadius = 5.0
        registerButton.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Register"
    }
    
    @IBAction func colorSelectionButtonClicked(_ sender: UIButton) {
        if let colorPickerController = UIStoryboard.initializeControllerFor(.colorPicker) as? ColorPickerController {
            colorPickerController.delegate = self
            present(colorPickerController, animated: true, completion: nil)
        }

    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if isNameProvided() {
            saveUserData()
            let scanController = ScanController()
            navigationController?.pushViewController(scanController, animated: true)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: ColorPickerDelegate {
    func selectedColor(_ color: UIColor) {
        colorSelectionButton.backgroundColor = color
        view.backgroundColor = color.withAlphaComponent(0.5)
        colorCode = AppConstants.colorsForDevices.firstIndex(of: color) ?? 0
    }
}

private extension RegisterViewController {
    
    /// Method for saving user info in a local object and then into UserDefaults
    func saveUserData() {
        var userData = UserData()
        userData.deviceName = deviceNameTextField.text ?? ""
        userData.colorCode = colorCode
        userData.save()
    }
    
    //Error checking method
    func isNameProvided() -> Bool{
        if let text = deviceNameTextField.text, text.count > 0 {
            return true
        } else {
            showAlertView(nil, message: "Please enter the device name")
            return false
        }
    }
}
