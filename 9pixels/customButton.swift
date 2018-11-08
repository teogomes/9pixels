//
//  customButton.swift
//  9pixels
//
//  Created by Teodoro Gomes on 08/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit

public class customButton :UIButton {
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    var myValue: Int
    
    required init(value: Int = 0) {
        // set myValue before super.init is called
        self.myValue = value
        super.init(frame: .zero)
         translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 14.0/255, green: 120.0/255, blue: 55.0/255, alpha: 1.0)
        layer.cornerRadius = 10

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
