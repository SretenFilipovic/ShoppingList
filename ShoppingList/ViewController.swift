//
//  ViewController.swift
//  ShoppingList
//
//  Created by Cubes on 14.10.22..
//

import UIKit

class ViewController: UITableViewController {

    let defaultShoppingList = UserDefaults.standard
    
    var shoppingList = [String]() {
        didSet {
            defaultShoppingList.set(shoppingList, forKey: "myItems")
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My shopping list"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        
        shoppingList = defaultShoppingList.object(forKey: "myItems") as? [String] ?? []
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
            }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    func submit(_ item: String) {
        
        let itemUppercased = item.uppercased()
        
        if item.count != 0 {
            if !shoppingList.contains(itemUppercased){
                shoppingList.insert(itemUppercased, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                
            } else {
                let ac = UIAlertController(title: "Invalid item", message: "You already have that item in you shopping list", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
          
        } else {
            let ac = UIAlertController(title: "Invalid item", message: "You must enter an item", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func clearList() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    

}

