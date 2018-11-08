//
//  customSegue.swift
//  9pixels
//
//  Created by Teodoro Gomes on 08/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit

class customSegue: UIStoryboardSegue {

    override func perform() {
        anim()
    }
    
    func anim(){
        let toViewController = self.destination.view
        let fromViewController = self.source.view
        
        // get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        toViewController!.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        
        // add destination view to view hierarchy
        UIApplication.shared.keyWindow?.insertSubview(toViewController!, aboveSubview: fromViewController!)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            toViewController!.transform = CGAffineTransform.identity
            
        }) { (success) in
           self.source.present(self.destination, animated: false, completion: nil)
           
        }
    }
}
