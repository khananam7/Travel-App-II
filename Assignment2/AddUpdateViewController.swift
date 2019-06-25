//
//  AddUpdateViewController.swift
//  Assignment2
//
//  Created by Anam Khan on 03/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import UIKit
import CoreData

class AddUpdateViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//outlets and actions
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var pickedImageView: UIImageView!
    
    @IBOutlet weak var pickimageButton: UIButton!
    var imagePicked = false
    var imagePicker = UIImagePickerController()
    @IBAction func pickedImageAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            //set up the picker
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .savedPhotosAlbum
            //present the picker
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //get image from info
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //place into image view
        pickedImageView.image = image
        imagePicked = true
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    func saveImage (name: String){
        //create file manager
        let fm = FileManager.default
        //get path to documents
        let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        //append name to path
        let fileURL = documentsDirectory.appendingPathComponent(name)
        //get image data -- get data from image view
        if let data = pickedImageView.image!.jpegData(compressionQuality:  1.0),
            !FileManager.default.fileExists(atPath: fileURL.path){
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
        else{
            do{
                try fm.removeItem(atPath: fileURL.path)                
            }
            catch{
                print("Cannot remove items")
            }
            let data = pickedImageView.image!.jpegData(compressionQuality:  1.0)
            do {
                // writes the image data to disk
                try data!.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    //core data objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var citiesManagedObject : CitiesList! = nil
    var countryManagedObject : CountryListCD! = nil
    var entity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    func save(){
        //save a new managed object
        //make a new managed object
        
        entity = NSEntityDescription.entity(forEntityName: "CitiesList", in: context)
        entity = NSEntityDescription.entity(forEntityName: "CountryListCD", in: context)
        citiesManagedObject = CitiesList(context: context)
        countryManagedObject = CountryListCD(context: context)
        
        if(nameTextField.text != "" || languageTextField.text != "" || countryTextField.text != "" || urlTextField.text != "" || currencyTextField.text != ""){
            //fill it with data from textfield
            citiesManagedObject.name     = nameTextField.text
            citiesManagedObject.language = languageTextField.text
            citiesManagedObject.country  = countryTextField.text
            citiesManagedObject.url      = urlTextField.text
            citiesManagedObject.currency = currencyTextField.text
            citiesManagedObject.image = nameTextField.text
            countryManagedObject.countryName = countryTextField.text
            saveImage(name : nameTextField.text!)
            //save it
            do{
                try context.save()
            }catch{
                print ("Core data does not save")
            }
        }        
        else{
            print("Please enter data")
            AddUpdateViewController.toastView(messsage: "Please fill data", view: self.view)
        }
    }
    
    func update(){
        //save cities managed object
        //fill it with data from textfield
        citiesManagedObject.name     = nameTextField.text
        citiesManagedObject.language = languageTextField.text
        citiesManagedObject.country  = countryTextField.text
        citiesManagedObject.url      = urlTextField.text
        citiesManagedObject.currency = currencyTextField.text
     //   countryManagedObject.countryName = countryTextField.text
        if (imagePicked == true) {
            citiesManagedObject.image = nameTextField.text
            saveImage(name : nameTextField.text!)
        }
        //save it
        do{
            try context.save()
        }catch{
            print ("Core data does not save")
        }
    }
    
    
    @IBOutlet weak var AddUpdateButton: UIButton!
    @IBAction func AddUpdateActon(_ sender: Any) {
        if citiesManagedObject != nil{
            update()
             AddUpdateViewController.toastView(messsage: "Successfully Updated", view: self.view)
        }
        else{
            save()
             AddUpdateViewController.toastView(messsage: "Successfully Added", view: self.view)
        }
        navigationController?.popViewController(animated: true)
    }
    
    class  func toastView(messsage : String, view: UIView ){
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300,  height : 35))
        //   toastLabel.backgroundColor = UIColor().HexToColor(hexString: primary_color)
        toastLabel.backgroundColor = UIColor.green
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = messsage
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickimageButton.layer.cornerRadius = 20
        AddUpdateButton.layer.cornerRadius = 20
        if citiesManagedObject != nil
        { self.title = "Update City"
            AddUpdateButton.setTitle("Update", for: .normal)
        }
        else
        { self.title = "Add City"
             AddUpdateButton.setTitle("Add", for: .normal)
            pickedImageView.image = UIImage(named: "defaultImage")
        }
        imagePicked = false
        if citiesManagedObject != nil {
            nameTextField.text = citiesManagedObject.name
            languageTextField.text = citiesManagedObject.language
            countryTextField.text = citiesManagedObject.country
            urlTextField.text = citiesManagedObject.url
            currencyTextField.text = citiesManagedObject.currency
            if (citiesManagedObject.image != nil){
                let fm = FileManager.default
                //get path to documents
                let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
                //append name to path
                let fileURL = documentsDirectory.appendingPathComponent(citiesManagedObject.image!)
                if (fm.fileExists(atPath: fileURL.path)) {
                    let image    = UIImage(contentsOfFile: fileURL.path)
                    pickedImageView.image = image
                }
                else{
                   pickedImageView.image = UIImage(named: citiesManagedObject.image!)
                }
            }
           // if(citiesManagedObject.image != nil){pickedImageView.image = UIImage(named: citiesManagedObject.image!)}
            else{pickedImageView.image = UIImage(named: "defaultImage")}
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    

}
