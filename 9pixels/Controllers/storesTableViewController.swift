//
//  storesTableViewController.swift
//  9pixels
//
//  Created by Teodoro Gomes on 08/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit


struct Store {
    let name:String
    let address:String
    let postalCode:String
    var latidude:NSNumber = 0
    var longitude:NSNumber = 0
    
    init(json:[String:Any]){
        name = json["name"] as? String ?? ""
        address = json["address"] as? String ?? ""
        postalCode = json["postal_code"] as? String ?? ""
    }
    
}

struct MapPoints {
    let latidude:NSNumber
    let longitude:NSNumber
    
    init(json:[String:Any]){
        latidude = json["lat"] as? NSNumber ?? 0
        longitude = json["lng"] as? NSNumber ?? 0
    }
}

class storesTableViewController: UITableViewController{
    var Stores: [Store] = []
    var mapList: [MapPoints] = []
    var roundButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        insertButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                
            }
        }
    }
    func insertButton(){
        roundButton = customButton(value: 0)
        roundButton.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 0),
                    keyWindow.bottomAnchor.constraint(equalTo: self.roundButton.bottomAnchor, constant: -10),
                    self.roundButton.widthAnchor.constraint(equalToConstant: self.view.frame.width),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 65)])
            }
            //text and image
            self.roundButton.imageView?.sizeToFit()
            self.roundButton.setImage(UIImage(named: "map_icon"), for: .normal)
            self.roundButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 50, bottom: 10, right: self.roundButton.bounds.width - 110)
            self.roundButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: (self.roundButton.imageView?.frame.width)!)
            
            self.roundButton.setTitle("View on on Map", for: .normal)
            
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let screenHeight = UIScreen.main.bounds.size.height
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.roundButton.transform = CGAffineTransform.identity
            self.roundButton.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
            
        }) { (success) in
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
            }
        }
    
       
        
        performSegue(withIdentifier: "mapSegue", sender: self)
    }
    
    
    func fetchData(){
        
        let jsonUrlString = "https://api.myjson.com/bins/taw6u"
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else {return}
            
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: .mutableContainers) as AnyObject
                
                if let content = jsonResponse["data"] as? NSArray{
                    
                    for subContent in content {
                        let dataOfSub = subContent as? NSDictionary
                        
                        let map = dataOfSub?["map_point"] as! [String : Any]
                        
                        var store = Store(json: dataOfSub?["data"] as! [String : Any])
                        store.latidude = map["lat"] as! NSNumber
                        store.longitude = map["lng"] as! NSNumber

                        self.Stores.append(store)
                    }
                    
                }
              
                
            }catch let jsonErr{
                print(jsonErr)
            }
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            }.resume()
    }
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Stores[indexPath.row].name
        cell.detailTextLabel?.text = Stores[indexPath.row].address + ",TK:" + Stores[indexPath.row].postalCode
        return cell
    }
    
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MapViewController
       vc.Stores = Stores
    }
    
    
}
