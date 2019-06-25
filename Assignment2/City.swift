//
//  City.swift
//  CityInformation
//
//  Created by Anam Khan on 17/02/19.
//  Copyright © 2019 UCC. All rights reserved.
//

import Foundation
class City{
    //properties
    var name     : String
    var country  : String
    var language : String
    var url      : String
    var currency : String
    var image    : String
    var image2   : String
    var image3   : String
    
    //initializer
    
    init(){
        self.name     = "Paris"
        self.country  = "France"
        self.language = "French"
        self.url      = "https://en.wikipedia.org/wiki/Paris"
        self.currency = "Euro"
        self.image    = "none"
        self.image2   = "none"
        self.image3   = "none"
    }
    
    init(name:String,country:String,language:String,url:String,currency:String,image:String,image2:String,image3:String){
        self.name     = name
        self.country  = country
        self.language = language
        self.url      = url
        self.currency = currency
        self.image    = image
        self.image2    = image2
        self.image3    = image3
    }
    //methods
    func setName(name:String){self.name = name}
    func getName() -> String {return self.name}
    
    func setCountry(country:String){self.country = country}
    func getCountry() -> String {return self.country}
    
    func setLanguage(language:String){self.language = language}
    func getLanguage() -> String {return self.language}
    
    func setUrl(url:String){self.url = url}
    func getUrl() -> String {return self.url}
    
    func setCurrency(currency:String){self.currency = currency}
    func getCurrency() -> String {return self.currency}
    
    func setImage(image:String){self.image = image}
    func getImage() -> String {return self.image}
    
    func setImage2(image2:String){self.image2 = image2}
    func getImage2() -> String {return self.image2}
    
    func setImage3(image3:String){self.image3 = image3}
    func getImage3() -> String {return self.image3}
    
}


