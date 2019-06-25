//
//  CityList.swift
//  CityInformation
//
//  Created by Anam Khan on 17/02/19.
//  Copyright © 2019 UCC. All rights reserved.
//

import Foundation
class CityList{
    
    //properties
    
    let citiesData : [City]
    //init
    init(){
        citiesData = [
            City(name: "Paris", country: "France", language: "French", url: "https://en.wikipedia.org/wiki/Paris", currency: "Euro", image: "paris.jpg", image2: "paris.jpg",image3: "paris.jpg")]
    }
    
    init(fromContentOfXML :  String){
        let parser = XMLCitiesParser(name : fromContentOfXML)
        parser.parsing()
        citiesData = parser.cities
    }
    
    //methods
    func count()->Int{return citiesData.count}
    func cityData(index:Int)->City{return citiesData[index]}
}
