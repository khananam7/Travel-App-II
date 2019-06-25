//
//  XMLCountryParser.swift
//  Assignment2
//
//  Created by Anam Khan on 07/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import Foundation

class XMLCountryParser : NSObject, XMLParserDelegate{
    var name : String
    init(name:String){self.name = name}
    
    //variable to hold tag data
    var cName : String!
    
    //var to spy during parsing
    var passData = false
    var elementID = -1
    
    //var to manage data
    var country = Country()
    var countryList = [Country]()
    
    var parser = XMLParser()
    var tags = ["name"]
    
    //func to read char between tags
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if passData{
            switch elementID{
            case 0 : cName     = string
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
            default         : break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if tags.contains(elementName){
            passData = false
            elementID = -1
        }
        if elementName.contains("country"){
            country = Country(name: cName)
            countryList.append(country)
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
