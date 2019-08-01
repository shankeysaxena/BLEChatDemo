//
//  BuildChoiceViewController.swift
//  BLEDemo
//
//  Created by apple on 7/29/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

class BuildChoiceViewController: UIViewController {

    @IBOutlet weak var senderButton: UIButton!
    
    @IBOutlet weak var receiverButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        senderButton.addTarget(self, action: #selector(buildOptionsSelected), for: .touchUpInside)
        receiverButton.addTarget(self, action: #selector(buildOptionsSelected), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func buildOptionsSelected(_ sender: UIButton) {
        print(sender.tag)
        if let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
   
}
