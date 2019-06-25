//
//  CityTableViewController.swift
//  Assignment2
//
//  Created by Anam Khan on 02/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import UIKit
import  CoreData
class HeadlinetableViewCell : UITableViewCell {
    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var headlineTitle: UILabel!
}

class CityTableViewController: UITableViewController,NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    //core data part
    //core data objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var citiesManagedObject : CitiesList! = nil
    var countryManagedObject : CountryListCD! = nil    
    var entity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    @IBOutlet weak var citySearchbar: UISearchBar!
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self as? NSFetchedResultsControllerDelegate
        do{
            try
                
                	frc.performFetch()
        }
        catch{
            print("Core data cannot fetch")
        }
         tableView.reloadData()
    }
    
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult>{
        //request = predicate + sorter
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesList")
        //can have multiple sorters
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        //gets name same as anam
        // let predicate = NSPredicate(format: "%K == %@", "name", "Anam")
        // request.predicate = predicate
        if(citySearchbar.text != ""){
        let predicate1 = NSPredicate(format: "name contains[c] %@", citySearchbar.text!)
        let predicate2 = NSPredicate(format: "country contains[c] %@", countryManagedObject.countryName!)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        request.predicate = compound
        return request
        }
        else
        {
            let predicate = NSPredicate(format: "country contains[c] %@", countryManagedObject.countryName!)
            request.predicate = predicate
            return request
        }
    }
    
    
    func readDatafromXML(){
        var n : Int = citiesData.count()
        var i : Int = 0
        while (i != n){
            var tmp = NSEntityDescription.insertNewObject(forEntityName: "CitiesList", into: context)
            tmp.setValue(citiesData.cityData(index: i).name, forKey: "name")
            tmp.setValue(citiesData.cityData(index: i).country, forKey: "country")
            tmp.setValue(citiesData.cityData(index: i).language, forKey: "language")
            tmp.setValue(citiesData.cityData(index: i).url, forKey: "url")
            tmp.setValue(citiesData.cityData(index: i).currency, forKey: "currency")
            tmp.setValue(citiesData.cityData(index: i).image, forKey: "image")
            i = i+1
        }
        do{
            try context.save()
        }catch{
            print ("Core data does not save")
        }
    }
    /*
    func removeData (){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesList")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
 */
    
    //xml part
    var citiesData : CityList!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List of Cities"
        citiesData = CityList(fromContentOfXML: "cities.xml")
        citySearchbar.delegate = self
       // removeData()
        //read from array and push to core data
        do{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesList")
        let count = try context.count(for: fetch)
            if count == 0 { readDatafromXML()}
            else{}
        }
        catch{
            print("Error Occured loading data")
        }
        //prepare for fetching
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return citiesData.count()
        return frc.sections![section].numberOfObjects
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView.frame.height
        return 220
    }
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [
            UIColor(red:0.67, green:0.89, blue:0.82, alpha:1.0).cgColor,UIColor(red:0.64, green:0.78, blue:0.84, alpha:1.0).cgColor]
        return layer
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeadlinetableViewCell

        // Configure the cell...
        citiesManagedObject = frc.object(at: indexPath) as? CitiesList
        cell.layer.insertSublayer(gradient(frame: cell.bounds), at:0)
        cell.headlineTitle.text  = citiesManagedObject.name
        if (citiesManagedObject.image != nil){
            let fm = FileManager.default
            //get path to documents
            let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            //append name to path
            let fileURL = documentsDirectory.appendingPathComponent(citiesManagedObject.image!)
            if (fm.fileExists(atPath: fileURL.path)) {
                let image    = UIImage(contentsOfFile: fileURL.path)
                 cell.headlineImage.image = image
            }
            else{
                cell.headlineImage.image = UIImage(named: citiesManagedObject.image!)
            }
        }
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get managedobject to delete
            citiesManagedObject = (frc.object(at: indexPath) as! CitiesList)
            
            //delete it from context
            context.delete(citiesManagedObject)
            //save context
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


    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "viewSegue"{
            let destination = segue.destination as! CItyDetailedViewController
            //pass the selected cell
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            citiesManagedObject = (frc.object(at: indexPath!) as! CitiesList)
            destination.citiesManagedObject = citiesManagedObject
        }
        if segue.identifier == "addSegue"{
            let destination = segue.destination as! AddUpdateViewController
            //pass the selected cell
//            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
//            citiesManagedObject = (frc.object(at: indexPath!) as! CitiesList)
            destination.citiesManagedObject = nil
        }
    }
    
    
}
