//
//  CountryTableViewController.swift
//  Assignment2
//
//  Created by Anam Khan on 06/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import UIKit
import CoreData

class CountryTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,UISearchBarDelegate {
        
    @IBOutlet weak var searchBar: UISearchBar!
    var citiesManagedObject : CitiesList! = nil
    var citiesData : CityList!
    var countryData : CountryList!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    var citiesManagedObject : CitiesList! = nil
    var countryManagedObject : CountryListCD! = nil
    var entity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesData = CityList(fromContentOfXML: "cities.xml")
      countryData = CountryList(fromContentOfXML: "country.xml")
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70

    }
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult>{
        //request = predicate + sorter
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryListCD")
        let sorter = NSSortDescriptor(key: "countryName", ascending: true)
        request.sortDescriptors = [sorter]
        if(searchBar.text != ""){
        let predicate = NSPredicate(format: "countryName contains[c] %@", searchBar.text!)
        request.predicate = predicate
            return request
        }
        else
        {
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
            
//            tmp.setValue(ctemp, forKey: "countryName")
            i = i+1
        }
        var j = 1
        while j != countryData.count(){
            var ctemp = NSEntityDescription.insertNewObject(forEntityName: "CountryListCD", into: context)
            ctemp.setValue(countryData.countryData(index: j).name, forKey: "countryName")
            print(countryData.countryData(index: j).name)
            j = j+1

        }
        
        do{
            try context.save()
        }catch{
            print ("Core data does not save")
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

//    func gradient(frame:CGRect) -> CAGradientLayer {
//        let layer = CAGradientLayer()
//        layer.frame = frame
//        layer.startPoint = CGPoint(x: 0, y: 0.5)
//        layer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.colors = [
//            UIColor.white.cgColor,UIColor.blue.cgColor]
//        return layer
//    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       // cell.layer.insertSublayer(gradient(firstColor: .green, secondColor: .blue,frame: cell.bounds), at:0)
        cell.layer.insertSublayer(gradient(frame: cell.bounds), at:0)
        citiesManagedObject = frc.object(at: indexPath) as? CitiesList
        countryManagedObject = frc.object(at: indexPath) as? CountryListCD
//        cell.textLabel?.text  = countryManagedObject.countryName!
        (cell.viewWithTag(1) as! UILabel).text = countryManagedObject.countryName!
        print(countryManagedObject.countryName?.count)
      
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cityTableSegue"{
            let destination = segue.destination as! CityTableViewController
            //pass the selected cell
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            countryManagedObject = (frc.object(at: indexPath!) as! CountryListCD)
            destination.countryManagedObject = countryManagedObject
        }
        if segue.identifier == "checkwishlist"{
            let destination = segue.destination as! WishlistedTableViewController
        }
    }
    
}
