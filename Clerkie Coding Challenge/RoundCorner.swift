//
//  RoundCorner.swift
//  Clerkie Coding Challenge
//
//  Created by Prashant Verma on 8/24/18.
//  Copyright © 2018 Prashant Verma. All rights reserved.
//

import UIKit

@IBDesignable class RoundCorner: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
        //layer.borderColor = (UIColor.white as! CGColor)
        
    }
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


    



