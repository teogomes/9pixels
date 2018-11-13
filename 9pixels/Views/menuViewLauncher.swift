//
//  menuViewLauncher.swift
//  9pixels
//
//  Created by Teodoro Gomes on 13/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit

class menuViewLauncher: NSObject,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    let options = ["Αρχική" , "Καταστήματα","Αγαπημένα","Σχετικά με εμάς"]
    
    
    let menuView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        
        return view
    }()
    
    let blackView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        return view
    }()
    
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.3, alpha: 0.2)
        return cv
    }()
    
    func showMenu() {
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(customCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        
        
        
       
        if let window = UIApplication.shared.keyWindow {
            
            var menuViewWidth:CGFloat = 0.0
            
            
             collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            //stack view
            
            let profPic = UIImageView()
            profPic.image = UIImage(named: "profile_pic")
            profPic.contentMode = .scaleAspectFit
            
            let nameLabel = UILabel()
            nameLabel.text = "Teodoro Gomes"
            nameLabel.font = UIFont(name: "Arial", size: 22)
            nameLabel.textColor = .white
            nameLabel.numberOfLines = 2
            
            
            let settingsButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            settingsButton.image = UIImage(named: "options")
            settingsButton.contentMode = .scaleAspectFit
            settingsButton.clipsToBounds = true
            
            let arrangedSubview = [profPic,nameLabel,settingsButton]
            
            let stackView = UIStackView(arrangedSubviews: arrangedSubview)
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            stackView.alignment = .center
            stackView.backgroundColor = .gray
            stackView.translatesAutoresizingMaskIntoConstraints = false
        
            
            menuView.addSubview(stackView)
            menuView.addSubview(collectionView)
            window.addSubview(blackView)
            window.addSubview(menuView)
            
            menuViewWidth =  2 * window.frame.width / 3
            
            menuView.frame = CGRect(x: window.frame.width ,y: 0, width:menuViewWidth, height: window.frame.height)
            blackView.alpha = 0
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            
            
            //CONSTRAINTS
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 20),
                stackView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 5),
                stackView.trailingAnchor.constraint(equalTo:menuView.trailingAnchor, constant: -2),
                stackView.heightAnchor.constraint(equalToConstant: 150)
                ])
            
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
                collectionView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 0),
                collectionView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: 0),
                collectionView.heightAnchor.constraint(equalToConstant: 300)
                ])
            
            
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                self.menuView.frame = CGRect(x: window.frame.width - menuViewWidth, y: 0, width: menuViewWidth, height: self.menuView.frame.height)
                self.blackView.alpha = 1
                
            }, completion: nil)
           
         
            
        }
    }
    
    @objc func handleDismiss() {
     
        UIView.animate(withDuration: 0.5) {
            if let window = UIApplication.shared.keyWindow {
            self.menuView.frame = CGRect(x: window.frame.width ,y: 0, width: self.menuView.frame.width, height: window.frame.height)
            self.blackView.alpha = 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! customCollectionViewCell
        cell.textView.text = options[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 40)
    }

    
}
