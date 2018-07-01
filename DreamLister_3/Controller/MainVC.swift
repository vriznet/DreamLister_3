//
//  ViewController.swift
//  DreamLister_3
//
//  Created by vriz on 2018. 7. 1..
//  Copyright © 2018년 vriz. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    // IBOutlet
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // custom variables/constants
    var controller: NSFetchedResultsController<Item>!
    
    // overrided ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        generateTestData()
        attemptFetch()
    }
    
    // tableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell{
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // FRC functions
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
        case.insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath{
                if let cell = tableView.cellForRow(at: indexPath) as? ItemCell{
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
            break
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // custom functions
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        controller.delegate = self
        do{
            try controller.performFetch()
        }catch{
            let error = error as NSError
            print(error)
        }
    }
    func configureCell(cell: ItemCell, indexPath: IndexPath){
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
    func generateTestData(){
        let item1 = Item(context: context)
        item1.title = "Surface Book 2"
        item1.price = 3999
        item1.details = "Finally I got this!"
        let item2 = Item(context: context)
        item2.title = "BMW Z4"
        item2.price = 100000
        item2.details = "My First Dream Car"
    }
}

