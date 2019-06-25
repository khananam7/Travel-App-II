//
//  CountryList.swift
//  Assignment2
//
//  Created by Anam Khan on 07/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import Foundation
class CountryList{
    
    //properties
    
    let countryData : [Country]
    //init
    init(){
        countryData = [
            Country(name: "Paris")]
    }
    
    init(fromContentOfXML :  String){
        let parser = XMLCountryParser(name : fromContentOfXML)
        parser.parsing()
        countryData = parser.countryList
    }
    
    //methods
    func count()->Int{return countryData.count}
    func countryData(index:Int)->Country{return countryData[index]}
}
