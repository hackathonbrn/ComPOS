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
        fptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam: LIBFPTR_ALIGNMENT_CENTER.rawValue)
        fptr?.setParam(Int32(LIBFPTR_PARAM_FONT.rawValue), intParam: 2)
        fptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_WIDTH.rawValue), boolParam:true)
        fptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_HEIGHT.rawValue), boolParam:true)
        fptr?.printText()
        
        fptr?.setParam(Int32(LIBFPTR_PARAM_FILENAME.rawValue), nsStringParam: "/Users/maximbutin/Documents/Study/Hackathon/ComPOS/ComPOSiOS/img.bmp")
        fptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam:LIBFPTR_ALIGNMENT_CENTER.rawValue)
        fptr?.printPicture()
    }
    
    @IBAction func close(_ sender: Any) {
        fptr?.close()
    }
}

