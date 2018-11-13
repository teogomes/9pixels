//
//  menuViewLauncher.swift
//  9pixels
//
//  Created by Teodoro Gomes on 13/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit

class menuViewLauncher: NSObject {
    
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
    
    func showMenu() {
        
        
        
        if let window = UIApplication.shared.keyWindow {
            
            var menuViewWidth:CGFloat = 0.0
            
            window.addSubview(blackView)
            window.addSubview(menuView)
            menuViewWidth =  2 * window.frame.width / 3
            
            menuView.frame = CGRect(x: window.frame.width ,y: 0, width:menuViewWidth, height: window.frame.height)
            blackView.alpha = 0
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
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

}
