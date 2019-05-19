//
//  MainTableViewController.swift
//  ComPOSiOS
//
//  Created by Maxim Butin on 18/05/2019.
//  Copyright © 2019 Maxim Butin. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var products = [Product]()
    var selected: [Product] = []
    
    var currentfptr = IFptr()

    let productsRequest = ResourceRequest<Product>(resourcePath: "products")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarController
        currentfptr = tabBar.fptr
        
        tableView.tableFooterView = UIView()
        fetchProductData()
}
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarController
        currentfptr = tabBar.fptr
    }
    
    
    func fetchProductData() {

        productsRequest.getAll { [weak self] productResult in
            switch productResult {
            case .failure:
                print("Error")
            case .success(let products):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.products = products
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        print(indexPath.row)
        cell.textLabel?.text = products[indexPath.row].name
        cell.detailTextLabel?.text = "\(products[indexPath.row].retailPrice) ₽"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                selected.remove(at: 0)
            } else {
                cell.accessoryType = .checkmark
                selected.append(products[indexPath.row])
            }
        }
    }
    
    @IBAction func theMostPopularProduct(_ sender: Any) {
        
        var max = selected.first
        var sum = 0.0
        for select in selected {
            if max!.retailPrice < select.retailPrice {
                max = select
            }
            sum = sum + select.retailPrice
        }
        
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FILENAME.rawValue), nsStringParam: "/Users/maximbutin/Documents/Study/Hackathon/ComPOS/ComPOSiOS/logo.bmp")
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam:LIBFPTR_ALIGNMENT_CENTER.rawValue)
        currentfptr?.printPicture()
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam: LIBFPTR_ALIGNMENT_CENTER.rawValue)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT.rawValue), intParam: 2)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_WIDTH.rawValue), boolParam:true)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_HEIGHT.rawValue), boolParam:true)
        currentfptr?.printText()
        
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_TEXT.rawValue), nsStringParam: "--------------------------------------------")
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam: LIBFPTR_ALIGNMENT_CENTER.rawValue)
        currentfptr?.printText()
        
        for select in selected {
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_TEXT.rawValue), nsStringParam: "\(select.name) - \(select.retailPrice) ₽")
            currentfptr?.printText()
        }
        
        for _ in 1..<5 {
            currentfptr?.printText()
        }
        
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_TEXT.rawValue), nsStringParam: "ИТОГО")
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam: LIBFPTR_ALIGNMENT_LEFT.rawValue)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT.rawValue), intParam: 1)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_WIDTH.rawValue), boolParam:true)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_HEIGHT.rawValue), boolParam:true)
        currentfptr?.printText()
        
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_TEXT.rawValue), nsStringParam: "\(sum)")
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam: LIBFPTR_ALIGNMENT_LEFT.rawValue)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT.rawValue), intParam: 1)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_WIDTH.rawValue), boolParam:true)
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_FONT_DOUBLE_HEIGHT.rawValue), boolParam:true)
        currentfptr?.printText()
        
        if max?.retailPrice == 543.0 {
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_FILENAME.rawValue), nsStringParam: "/Users/maximbutin/Documents/Study/Hackathon/ComPOS/ComPOSiOS/cokteil.bmp")
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam:LIBFPTR_ALIGNMENT_CENTER.rawValue)
            currentfptr?.printPicture()
        } else if max?.retailPrice == 4124.0 {
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_FILENAME.rawValue), nsStringParam: "/Users/maximbutin/Documents/Study/Hackathon/ComPOS/ComPOSiOS/burger.bmp")
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam:LIBFPTR_ALIGNMENT_CENTER.rawValue)
            currentfptr?.printPicture()
        } else if max?.retailPrice == 245.0 {
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_FILENAME.rawValue), nsStringParam: "/Users/maximbutin/Documents/Study/Hackathon/ComPOS/ComPOSiOS/gum.bmp")
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam:LIBFPTR_ALIGNMENT_CENTER.rawValue)
            currentfptr?.printPicture()
        } else {
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_FILENAME.rawValue), nsStringParam: "/Users/maximbutin/Documents/Study/Hackathon/ComPOS/ComPOSiOS/img.bmp")
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_ALIGNMENT.rawValue), intParam:LIBFPTR_ALIGNMENT_CENTER.rawValue)
            currentfptr?.printPicture()
        }
        
        currentfptr?.endNonfiscalDocument()
    }

    @IBAction func connect(_ sender: Any) {
        currentfptr?.open()
    }
}
