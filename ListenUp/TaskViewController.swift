//
//  TaskViewController.swift
//  ListenUp
//
//  Created by Thomas Clavelli on 9/18/17.
//  Copyright © 2017 Thomas Clavelli. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var forList: List?
    var tasks: [Task]?

    override func viewWillAppear(_ animated: Bool) {
        tasks = forList?.tasks?.allObjects as? [Task]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addTask(_ sender: Any) {
        let context: NSManagedObjectContext = DatabaseController.persistentContainer.viewContext
        let alert = UIAlertController(title: "New Task", message: "Enter a task title", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            if textField.text! != "" {
                let task: Task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
                task.title = textField.text!
                task.completed = false
                self.forList?.addToTasks(task)
                self.tasks!.append(task)
                self.table.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task")!
        cell.textLabel?.text = tasks![indexPath.row].title
        if tasks![indexPath.row].completed {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let context: NSManagedObjectContext = DatabaseController.persistentContainer.viewContext
            context.delete(tasks![indexPath.row])
            tasks!.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            tasks![indexPath.row].completed = false
        } else {
            cell?.accessoryType = .checkmark
            tasks![indexPath.row].completed = true
        }
    }

}
