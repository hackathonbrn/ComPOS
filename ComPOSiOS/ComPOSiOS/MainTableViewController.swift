//
//  MainTableViewController.swift
//  ComPOSiOS
//
//  Created by Maxim Butin on 18/05/2019.
//  Copyright © 2019 Maxim Butin. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var categories = [Category]()
    var products = [Product]()
    
    let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
    let productsRequest = ResourceRequest<Product>(resourcePath: "products")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryData()
        fetchProductData()
    }
    
    func fetchCategoryData() {
        categoriesRequest.getAll { [weak self] categoryResult in
            switch categoryResult {
            case .failure:
                print("Error")
            case .success(let categories):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.categories = categories
                    self.tableView.reloadData()
                }
            }
        }
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
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let category = categories[indexPath.row]
//        cell.textLabel?.text = "\(category.name)"
//        cell.detailTextLabel?.text = "\(category.id)"
        let product = products[indexPath.row]
        cell.textLabel?.text = "\(product.name)"
        for category in categories {
            if category.id == product.category_fk {
                print(product.category_fk)
                cell.detailTextLabel?.text = "\(category.name)"
            }
        }
        
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
