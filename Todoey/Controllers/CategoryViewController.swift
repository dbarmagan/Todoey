//
//  CategoryViewController.swift
//  Todoey
//
//  Created by armagan ozdemir on 17.01.2019.
//  Copyright © 2019 armagan ozdemir. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories=[Category]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category=categories[indexPath.row]
        
        cell.textLabel?.text=category.name
        
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error fetching data from categories, \(error)")
        }
        tableView.reloadData()
    }

    

    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //MARK: - Add New Categories
            
            var textField=UITextField()
            let alert = UIAlertController(title: "Add New Todoey Category", message: "army", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                //What will happen once the user click tha Add Item button on our UIAlert
                
                let newCategory=Category(context: self.context)
                
                newCategory.name=textField.text!
                
                self.categories.append(newCategory)
                
                self.saveCategories()
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
            destinationVC.selectedCategory=categories[indexPath.row]
        }
    }
    
    
    
    
}
