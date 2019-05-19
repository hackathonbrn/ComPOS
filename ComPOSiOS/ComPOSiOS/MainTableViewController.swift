//
//  MainTableViewController.swift
//  ComPOSiOS
//
//  Created by Maxim Butin on 18/05/2019.
//  Copyright © 2019 Maxim Butin. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    //var categories = [Category]()
    var products = [Product]()
    var selected: [Product] = []
    
    var currentfptr = IFptr()

    //var productsInCategory: [Int: [Product]] = [:]

    //let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
    let productsRequest = ResourceRequest<Product>(resourcePath: "products")
    
//    let group = DispatchGroup()
//    let groupp = DispatchGroup()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarController
        currentfptr = tabBar.fptr
        
        tableView.tableFooterView = UIView()
        fetchProductData()
        
        
//        group.enter()
//        let queue = DispatchQueue(label: "work3")
//        queue.async { self.fetchCategoryData() }
//        group.wait()
//
//        groupp.enter()
//        let queue1 = DispatchQueue(label: "work4")
//        queue1.async { self.fetchProductData() }
//        groupp.wait()
//
//        correlateProductsWithCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarController
        currentfptr = tabBar.fptr
    }
    
//    func correlateProductsWithCategories() {
//        for product in products {
//            if productsInCategory[product.category_fk] != nil {
//                productsInCategory.updateValue(productsInCategory[product.category_fk]! + [product], forKey: product.category_fk)
//            } else {
//                productsInCategory.updateValue([product], forKey: product.category_fk)
//            }
//        }
//    }
    
//    func fetchCategoryData() {
//        let queue = DispatchQueue(label: "work2")
//        categoriesRequest.getAll { [weak self] categoryResult in
//            switch categoryResult {
//            case .failure:
//                print("Error")
//            case .success(let categories):
//                queue.async {
//                    guard let self = self else { return }
//                    self.categories = categories
//                    self.group.leave()
//                }
//
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//
//                }
//            }
//        }
//    }
    
    func fetchProductData() {
        //let queue = DispatchQueue(label: "work1")
        productsRequest.getAll { [weak self] productResult in
            switch productResult {
            case .failure:
                print("Error")
            case .success(let products):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.products = products
                    self.tableView.reloadData()
                    //self.groupp.leave()
                }
                
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
            }
        }
    }
    

    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        var categoryTitle = [String]()
//
//        for categoryID in productsInCategory.keys {
//            for category in categories {
//                if categoryID == category.id {
//                    categoryTitle.append(category.name)
//                }
//            }
//        }
//
//        return categoryTitle[section]
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return categories.count
//    }

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
        
        currentfptr?.setParam(Int32(LIBFPTR_PARAM_TEXT.rawValue), nsStringParam: "СOMPOS")
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
        } else if max?.retailPrice == 4124 {
            currentfptr?.setParam(Int32(LIBFPTR_PARAM_FILENAME.rawValue), nsStringParam: "/Users/maximbutin/Documents/Study/Hackathon/ComPOS/ComPOSiOS/burger.bmp")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
