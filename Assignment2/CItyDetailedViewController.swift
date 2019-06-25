//
//  CItyDetailedViewController.swift
//  Assignment2
//
//  Created by Anam Khan on 03/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import UIKit
import CoreData

class CItyDetailedViewController: UIViewController {

    //outlets and actions
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var Cityimage: UIImageView!
    @IBOutlet weak var isWishlisted: UISwitch!
    
    @IBOutlet weak var moreimageButton: UIButton!
    @IBAction func wishListAction(_ sender: UISwitch) {
        if(sender.isOn == true){
            citiesManagedObject.wishlist = true
            CItyDetailedViewController.toastView(messsage: "Added to wishlist", view: self.view)
        }
        else{
            citiesManagedObject.wishlist = false
            CItyDetailedViewController.toastView(messsage: "Removed from wishlist", view: self.view)
        }
        do{
            try context.save()
        }catch{
            print ("Core data does not save")
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var citiesManagedObject : CitiesList! = nil
    var entity : NSEntityDescription! = nil
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "City Information"
        moreimageButton.layer.cornerRadius = 20
        nameLabel.text = citiesManagedObject.name
        currencyLabel.text = citiesManagedObject.currency
        countryLabel.text = citiesManagedObject.country
        languageLabel.text = citiesManagedObject.language
        if (citiesManagedObject.image != nil){
            let fm = FileManager.default
            //get path to documents
            let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            //append name to path
            let fileURL = documentsDirectory.appendingPathComponent(citiesManagedObject.image!)
            if (fm.fileExists(atPath: fileURL.path)) {
                let image    = UIImage(contentsOfFile: fileURL.path)
                 Cityimage.image  = image
            }
            else{
                 Cityimage.image  = UIImage(named: citiesManagedObject.image!)
            }
        }
        else{Cityimage.image = UIImage(named: "defaultImage")}
        if (citiesManagedObject.wishlist == true)
        {isWishlisted.setOn(true, animated: true)}
        else
        {isWishlisted.setOn(false, animated: true)}
        // Do any additional setup after loading the view.
    }
    
    class  func toastView(messsage : String, view: UIView ){
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-50, width: 300,  height : 35))
     //   toastLabel.backgroundColor = UIColor().HexToColor(hexString: primary_color)
        toastLabel.backgroundColor = UIColor.green
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = messsage
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 15;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateSegue"{
            let destination = segue.destination as! AddUpdateViewController
            //pass the selected cell
            destination.citiesManagedObject = citiesManagedObject
        }
        if segue.identifier == "imagepopover"{
            let destination = segue.destination as! ImagePopoverViewController
            //pass the selected cell
            destination.url = citiesManagedObject.url
        }
        if segue.identifier == "updateSegue"{
            let destination = segue.destination as! AddUpdateViewController
            //pass the selected cell
            destination.citiesManagedObject = citiesManagedObject
        }
    }
    

}
