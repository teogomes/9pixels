//
//  customCollectionViewCell.swift
//  efood
//
//  Created by Teodoro Gomes on 13/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit

class customCollectionViewCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let textbox = UITextView(frame: .zero)
        textbox.isEditable = false
        textbox.textColor = .white
        textbox.backgroundColor = .clear
        textbox.font = UIFont(name: "Arial", size: 20)
        textbox.textAlignment = .right
       
        return textbox
    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        textView.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    @objc func handleTap(gesture : UITapGestureRecognizer) {
        let textBox = gesture.view as! UITextView
        print(textBox.text)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
