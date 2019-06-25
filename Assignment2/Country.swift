//
//  Country.swift
//  Assignment2
//
//  Created by Anam Khan on 07/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import Foundation
class Country{
    //properties
    var name     : String

    //initializer
    
    init(){
        self.name     = "Paris"
    }
  
    init(name:String){
        self.name     = name
       
    }
    //methods
    func setName(name:String){self.name = name}
    func getName() -> String {return self.name}
    
    
}


