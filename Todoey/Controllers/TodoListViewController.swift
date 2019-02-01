//
//  ViewController.swift
//  Todoey
//
//  Created by armagan ozdemir on 12.01.2019.
//  Copyright © 2019 armagan ozdemir. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm=try! Realm()
    
    var selectedCategory:Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode:String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarClour = UIColor(hexString : colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarClour
        
        navBar.tintColor = ContrastColorOf(navBarClour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarClour, returnFlat: true)]
        
        searchBar.barTintColor = navBarClour
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item=todoItems?[indexPath.row]{
            cell.textLabel?.text=item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
              cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            // Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text="No Items Added"
        }

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item=todoItems?[indexPath.row]{
            do{
                try realm.write {
                  item.done = !item.done
                }
            }catch{
                print("Error saving done status,\(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField=UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "army", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user click tha Add Item button on our UIAlert
          
            if let currentCategory=self.selectedCategory{
                        do {
                try self.realm.write {
                    let newItem=Item()
                    newItem.title=textField.text!
                    newItem.dateCreated=Date()
                    currentCategory.items.append(newItem)
                }
                }catch {
                            print("Error saving new items, \(error)")
                }
                self.tableView.reloadData()

        }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new item"
            textField=alertTextField
          
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
//    func saveItems() {
//        
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context, \(error)")
//        }
//        tableView.reloadData()
//
//    }
    
    func loadItems() {
        
        todoItems=selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
            //tableView.reloadData()
        }
    }
    
    
}
//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems=todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }



}
