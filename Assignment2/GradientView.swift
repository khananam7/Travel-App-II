//
//  GradientView.swift
//  CityInformation
//
//  Created by Anam Khan on 06/03/19.
//  Copyright © 2019 UCC. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    //makes property show up in interface builder
    @IBInspectable var FirstColor : UIColor = UIColor.clear{
        //detect if person changes color from storyboard
        didSet{
            updateView()
        }
    }
    @IBInspectable var SecondColor : UIColor = UIColor.clear{
        didSet{
            updateView()
        }
        
    }
    
    override class var layerClass : AnyClass{
        get {
            return CAGradientLayer.self
        }
    }
    
    func  updateView()  {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
        layer.locations = [0.3 ]
    }
    
    
}
