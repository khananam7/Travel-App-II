//
//  XMLCitiesParser.swift
//  CityInformation
//
//  Created by Anam Khan on 18/02/19.
//  Copyright © 2019 UCC. All rights reserved.
//

import Foundation
class XMLCitiesParser : NSObject, XMLParserDelegate{
    var name : String
    init(name:String){self.name = name}
    
    //variable to hold tag data
    var pName, pCountry, pLanguage, pUrl, pCurrency, PImage, PImage2, PImage3 : String!
    
    //var to spy during parsing
    var passData = false
    var elementID = -1
    
    //var to manage data
    var city = City()
    var cities = [City]()
    
    var parser = XMLParser()
    var tags = ["name", "country", "language", "url", "currency", "image", "image2", "image3"]
    
    //func to read char between tags
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if passData{
            switch elementID{
                case 0 : pName     = string
                case 1 : pCountry  = string
                case 2 : pLanguage = string
                case 3 : pUrl      = string
                case 4 : pCurrency = string
                case 5 : PImage    = string
                case 6 : PImage2   = string
                case 7 : PImage3   = string
                default: break
            }
        }
    }
    
    //func to detect start and end tag
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //if element name in tags then spy
        
        if tags.contains(elementName){
            passData = true
            switch elementName{
            case "name"     : elementID = 0
            case "country"  : elementID = 1
            case "language" : elementID = 2
            case "url"      : elementID = 3
            case "currency" : elementID = 4
            case "image"    : elementID = 5
            case "image2"    : elementID = 6
            case "image3"    : elementID = 7
            default         : break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if tags.contains(elementName){
            passData = false
            elementID = -1
        }
        if elementName.contains("city"){
            city = City(name: pName, country: pCountry, language: pLanguage, url: pUrl, currency: pCurrency, image: PImage, image2: PImage2, image3: PImage3)
            cities.append(city)
        }
    }
    
    func parsing(){
        let bundleUrl = Bundle.main.bundleURL
        let fileUrl   = URL(string: self.name, relativeTo: bundleUrl)
        
        //make a parser
        parser = XMLParser(contentsOf: fileUrl!)!
        parser.delegate = self
        parser.parse()
    }
    
}
