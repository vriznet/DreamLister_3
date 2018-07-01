//
//  ItemDetailsVC.swift
//  DreamLister_3
//
//  Created by vriz on 2018. 7. 1..
//  Copyright © 2018년 vriz. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate {
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
    
    var itemToEdit: Item!
    
    var imagePicker: UIImagePickerController!
    
    // overrided ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        typePicker.delegate = self
        typePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        generateTestComponents()
        getStores()
        getTypes()
        if itemToEdit != nil{
            loadItemData()
        }
        
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
    
    // imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            thumbImg.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // IBActions
    @IBAction func savePressed(_ sender: UIButton) {
        let item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        if itemToEdit != nil{
            item = itemToEdit
        }else{
            item = Item(context: context)
        }
        item.toImage = picture
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
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil{
            context.delete(itemToEdit)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
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
    func loadItemData(){
        if let item = itemToEdit{
            thumbImg.image = item.toImage?.image as? UIImage
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            if let store = item.toStore{
                var store_index = 0
                repeat{
                    let s = stores[store_index]
                    if s.name == store.name{
                        storePicker.selectRow(store_index, inComponent: 0, animated: true)
                        break
                    }
                    store_index += 1
                }while(store_index < stores.count)
            }
            if let type = item.toItemType{
                var type_index = 0
                repeat{
                    let t = types[type_index]
                    if t.type == type.type{
                        typePicker.selectRow(type_index, inComponent: 0, animated: true)
                        break
                    }
                    type_index += 1
                }while(type_index < types.count)
            }
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
