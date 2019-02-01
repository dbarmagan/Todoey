//
//  CategoryViewController.swift
//  Todoey
//
//  Created by armagan ozdemir on 17.01.2019.
//  Copyright © 2019 armagan ozdemir. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm=try! Realm()
    
    var categories:Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.separatorStyle = .none
        
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
        
        
        
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category:Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories=realm.objects(Category.self)

        tableView.reloadData()
        }

    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            //tableView.reloadData()
        }
    }

    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //MARK: - Add New Categories
            
            var textField=UITextField()
            let alert = UIAlertController(title: "Add New Todoey Category", message: "army", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                //What will happen once the user click tha Add Item button on our UIAlert
                
                let newCategory=Category()
                
                newCategory.name=textField.text!
                newCategory.color=UIColor.randomFlat.hexValue()
                
                self.save(category: newCategory)
            }
            alert.addTextField { (field) in
                textField=field
                field.placeholder="Create new category"
                
                
            }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoListViewController
        
        if let indexPath=tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory=categories?[indexPath.row]
        }
    }
    
    
}


