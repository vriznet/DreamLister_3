//
//  ItemDetailsVC.swift
//  DreamLister_3
//
//  Created by vriz on 2018. 7. 1..
//  Copyright © 2018년 vriz. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // IBOutlets
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    
    // custom variables/constants
    var stores = [Store]()
    var types = [ItemType]()
    var isGenerated = [Generated]()
    
    // overrided ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        typePicker.delegate = self
        typePicker.dataSource = self
        
        generateTestComponents()
        getStores()
        getTypes()
        
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }
    
    // pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == storePicker{
            return stores.count
        }else if pickerView == typePicker{
            return types.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == storePicker{
            return self.stores[row].name
        }else if pickerView == typePicker{
            return self.types[row].type
        }
        return ""
    }
    
    // IBActions
    @IBAction func savePressed(_ sender: UIButton) {
        let item = Item(context: context)
        if let title = titleField.text{
            item.title = title
        }
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = types[typePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    
    // custom functions
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }catch{
            let error = error as NSError
            print(error)
        }
    }
    func getTypes(){
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do{
            self.types = try context.fetch(fetchRequest)
            self.typePicker.reloadAllComponents()
        }catch{
            let error = error as NSError
            print(error)
        }
    }
    func generateTestComponents(){
        let fetchRequest: NSFetchRequest<Generated> = Generated.fetchRequest()
        do{
            self.isGenerated = try context.fetch(fetchRequest)
        }catch{
            let error = error as NSError
            print(error)
        }
        let IsGenerated = self.isGenerated.count
        
        if IsGenerated == 0{
            let store1 = Store(context: context)
            store1.name = "Amazon"
            let store2 = Store(context: context)
            store2.name = "Fry"
            let store3 = Store(context: context)
            store3.name = "K Mart"
            let store4 = Store(context: context)
            store4.name = "emart"

            let type1 = ItemType(context: context)
            type1.type = "Car"
            let type2 = ItemType(context: context)
            type2.type = "Computer"
            let type3 = ItemType(context: context)
            type3.type = "Camera"
            let type4 = ItemType(context: context)
            type4.type = "Audio"

            ad.saveContext()
            let isGenerated = Generated(context: context)
            isGenerated.isGenerated = true
        }
    }
}
