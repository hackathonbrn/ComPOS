//
//  ViewController.swift
//  ComPOSiOS
//
//  Created by Maxim Butin on 17/05/2019.
//  Copyright © 2019 Maxim Butin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let fptr = IFptr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fptr?.setSingleSetting(LIBFPTR_SETTING_IPADDRESS, value: "192.168.1.146")
        fptr?.setSingleSetting(LIBFPTR_SETTING_PORT, value: "2")
        fptr?.setSingleSetting(LIBFPTR_SETTING_IPPORT, value: "5555")
        fptr?.applySingleSettings()
        
        fptr?.getSettings()
    }
    
    @IBAction func connect(_ sender: Any) {
        fptr?.open()
        
    }
    
    @IBAction func print(_ sender: Any) {
        fptr?.setParam(Int32(LIBFPTR_PARAM_TEXT.rawValue), nsStringParam: "Hackathon Barnaul")
        fptr?.printText()
    }
    
    @IBAction func close(_ sender: Any) {
        fptr?.close()
    }
}

