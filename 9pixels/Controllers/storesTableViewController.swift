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

class storesTableViewController: UITableViewController{
    var Stores: [Store] = []
    @IBOutlet var table: UITableView!
    var roundButton = UIButton()
    var dataOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        table.alwaysBounceVertical=false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        insertButton()
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
            self.roundButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: self.roundButton.bounds.width - 150)
            self.roundButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: (self.roundButton.imageView?.frame.width)!)
            self.roundButton.setTitle("View on on Map", for: .normal)
            self.roundButton.isHidden = false
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if dataOK {
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
        }else{
            print("Wait Data to Load")
        }
    }
    
    func fetchData(){
        guard let url = URL(string: "https://api.myjson.com/bins/taw6u") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
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
                self.dataOK = true
            }
            }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Stores.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.7
        scaleAnimation.repeatCount = 3.0
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1.0;
        scaleAnimation.toValue = 1.07;
        roundButton.layer.add(scaleAnimation, forKey: "scale")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Hiding the button to show last record
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height )
        {
          self.roundButton.isHidden = true
        }else{
            self.roundButton.isHidden = false
        }
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = UIColor.red //Color of scrollbar
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
