//
//  ViewController.swift
//  9pixels
//
//  Created by Teodoro Gomes on 08/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit
import MapKit



class MapViewController: UIViewController,CLLocationManagerDelegate , MKMapViewDelegate , UISearchBarDelegate {
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    let manager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var Stores:[Store] = []
    var myAnnotations:[MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        

        //Location Manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
      
        addAnnotations()
    }
    
    
    func addAnnotations(){
        
        let annotation = MKPointAnnotation()
       
        
        annotation.title = ""
        annotation.coordinate = CLLocationCoordinate2DMake(23.76, 37.88)
        map.addAnnotation(annotation)
        for store in Stores {
            
           let annotation = MKPointAnnotation()
            annotation.title = store.name
            annotation.subtitle = store.address
            annotation.coordinate = CLLocationCoordinate2DMake(Double(store.longitude), Double(store.latidude))
            myAnnotations.append(annotation)
            map.addAnnotation(annotation)
            map.tintColor = .green
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Starting to search
    
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activitySearch = MKLocalSearch(request: searchRequest)
        
        activitySearch.start { (response, error) in
            
            if response == nil {
                print("Error")
            }else{
              
                //Getting Data
                let latidude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Adding Annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latidude!, longitude!)
                let allAnnotations = self.map.annotations
                self.map.removeAnnotations(allAnnotations)
                
                self.map.addAnnotation(annotation)
                self.addAnnotations()
                //Zooming Annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latidude!, longitude!)
                let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                self.map.setRegion(region, animated: true)
            }
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        map.showsUserLocation = true
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        var annotationView = MKMarkerAnnotationView()
        let identifier = "mypin"
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        let pinIdentifier = myAnnotations.contains(where: { (MKAnnotation) -> Bool in
            if(MKAnnotation.isEqual(annotation)){
                return true
            }else{
                return false
            }
        })
        
        if pinIdentifier {
            annotationView.markerTintColor = .black
        }else{
            annotationView.markerTintColor = .green
        }
        
        
        
        
        return annotationView
        
    }
    
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

