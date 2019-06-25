//
//  WishlistedTableViewController.swift
//  Assignment2
//
//  Created by Anam Khan on 04/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import UIKit
import CoreData
class HeadlineTableViewCell: UITableViewCell{
    @IBOutlet weak var headlineTitle: UILabel!
    @IBOutlet weak var headlineText: UILabel!
}

class WishlistedTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var citiesManagedObject : CitiesList! = nil
    var entity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [
            UIColor(red:0.67, green:0.89, blue:0.82, alpha:1.0).cgColor,UIColor(red:0.64, green:0.78, blue:0.84, alpha:1.0).cgColor]
        return layer
    }
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult>{
        //request = predicate + sorter
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesList")
        //can have multiple sorters
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        //gets name same as anam
         let predicate = NSPredicate(format: "wishlist == %@", NSNumber(booleanLiteral: true))
        request.predicate = predicate
        return request
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self as? NSFetchedResultsControllerDelegate
        do{
            try
                
                frc.performFetch()
        }
        catch{
            print("Core data cannot fetch")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    return frc.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView.frame.height
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeadlineTableViewCell
        citiesManagedObject = frc.object(at: indexPath) as? CitiesList
        cell.layer.insertSublayer(gradient(frame: cell.bounds), at:0)
        cell.headlineTitle.text  = citiesManagedObject.name
        cell.headlineText.text = citiesManagedObject.country
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get managedobject to delete
            citiesManagedObject = (frc.object(at: indexPath) as! CitiesList)
            citiesManagedObject.wishlist = false
            do{
                try context.save()
            }catch{print("Core data does not save")}
            
            //fetch and reload
            do{
                try frc.performFetch()
            }catch{print("Core data does not fetch")}
            
            tableView.reloadData()
        }
    }
}
