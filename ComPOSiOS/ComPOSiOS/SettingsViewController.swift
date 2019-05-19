//
//  SettingsViewController.swift
//  ComPOSiOS
//
//  Created by Maxim Butin on 19/05/2019.
//  Copyright © 2019 Maxim Butin. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var ipadressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    
    var currentFptr = IFptr()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let tabBar = tabBarController as! TabBarController
        currentFptr = tabBar.fptr
        ipadressTextField.text = "192.168.1.147"
        portTextField.text = "5555"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarController
        tabBar.fptr = currentFptr
    }
    
    @IBAction func connect(_ sender: UIBarButtonItem) {
        
        currentFptr?.setSingleSetting(LIBFPTR_SETTING_IPADDRESS, value: ipadressTextField.text)
        currentFptr?.setSingleSetting(LIBFPTR_SETTING_PORT, value: "2")
        currentFptr?.setSingleSetting(LIBFPTR_SETTING_IPPORT, value: portTextField.text)
        currentFptr?.applySingleSettings()
        
        currentFptr?.getSettings()
        currentFptr?.open()
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    // MARK: - Hide keyboard when user touches outside keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ipadressTextField {
            portTextField.becomeFirstResponder()
        } else {
            portTextField.resignFirstResponder()
        }
        return true
    }
}

