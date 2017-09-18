//
//  ViewController.swift
//  ListenUp
//
//  Created by Thomas Clavelli on 9/17/17.
//  Copyright © 2017 Thomas Clavelli. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var lists = [List]()
    
    override func viewWillAppear(_ animated: Bool) {
        let context: NSManagedObjectContext = DatabaseController.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest = List.fetchRequest()
        
        do {
            lists = try context.fetch(fetchRequest) as [List]
        }
        catch {
            print("\(error)")
        }
        if table != nil {
            table.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func createNewList(_ sender: Any) {
        let context: NSManagedObjectContext = DatabaseController.persistentContainer.viewContext
        let list: List = NSEntityDescription.insertNewObject(forEntityName: "List", into: context) as! List
        let alert = UIAlertController(title: "New List", message: "Enter a list name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            list.title = textField.text!
            self.lists.append(list)
            self.table.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list")!
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.title!
        if list.tasks?.count == 0 {
            cell.accessoryView = blueDot()
        } else {
            cell.accessoryView = spinner(getPerc(list))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let context: NSManagedObjectContext = DatabaseController.persistentContainer.viewContext
            for task in lists[indexPath.row].tasks?.allObjects as! [Task] {
                context.delete(task)
            }
            context.delete(lists[indexPath.row])
            lists.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    var passing: List?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passing = lists[indexPath.row]
        performSegue(withIdentifier: "toList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toList" {
            let taskVC = segue.destination as! TaskViewController
            taskVC.title = passing?.title!
            taskVC.forList = passing
        }
    }
    
    func blueDot() -> UIImageView {
        let image = UIImageView(image: #imageLiteral(resourceName: "blue dot"))
        image.contentMode = .scaleAspectFit
        image.bounds.size = CGSize(width: 20, height: 14)
        return image
    }
    
    func spinner(_ perc: CGFloat) -> Spinner {
        let spinner = Spinner()
        spinner.bounds.size = CGSize(width: 20, height: 20)
        spinner.perc = perc
        spinner.backgroundColor = UIColor.white
        return spinner
    }
    
    func getPerc(_ list: List) -> CGFloat {
        let outOf = list.tasks!.count
        var completed: CGFloat = 0
        for task in list.tasks!.allObjects as! [Task] {
            if task.completed {
                completed += 1
            }
        }
        return completed / CGFloat(outOf)
    }

}

