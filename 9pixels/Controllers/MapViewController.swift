//
//  ViewController.swift
//  9pixels
//
//  Created by Teodoro Gomes on 08/11/2018.
//  Copyright © 2018 Teodoro Gomes. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces


class MapViewController: UIViewController,CLLocationManagerDelegate , MKMapViewDelegate , UISearchBarDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var roundButton: UIButton!
    let manager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var Stores:[Store] = []
    var apiAnnotations:[MKAnnotation] = []
    var myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0,0)
    
    //GOOGLE Places Stuff
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewWillLayoutSubviews() {
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.black
        roundButton.setImage(UIImage(named:"red_map_icon"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -23),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
        roundButton.tintColor = .white
        roundButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(){
        if(map.showsUserLocation){
            self.map.showsUserLocation = false
        }else{
            let span :MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
            let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
            map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GOOGLE PLACES FOR AUTOCOMPLETE
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as GMSAutocompleteResultsViewControllerDelegate
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: navigationBar.frame.height+30, width: 350.0, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
      
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.backgroundColor = .white
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        map.delegate = self
        map.tintColor = .green
        addAnnotations()
        
        //Location Manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func addAnnotations(){
        for store in Stores {
            let annotation = MKPointAnnotation()
            annotation.title = store.name
            annotation.subtitle = store.address
            annotation.coordinate = CLLocationCoordinate2DMake(Double(truncating: store.longitude), Double(truncating: store.latidude))
            apiAnnotations.append(annotation)
            map.addAnnotation(annotation)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) { return nil }
        
        var annotationView = MKMarkerAnnotationView()
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: "mypin") as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "mypin")
        }
        //Check if annotation is from Api List
        let pinIdentifier = apiAnnotations.contains(where: { (MKAnnotation) -> Bool in
            if(MKAnnotation.isEqual(annotation)){
                return true
            }else{
                return false
            }
        })
        //Black Color for the locations from Api green for anything else
        if pinIdentifier {
            annotationView.markerTintColor = .black
        }else{
            annotationView.markerTintColor = .green
        }

        return annotationView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// Handle the user's selection.
extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let annotation = MKPointAnnotation()
        annotation.title = place.name
        annotation.coordinate = place.coordinate
        let allAnnotations = self.map.annotations
        self.map.removeAnnotations(allAnnotations)
        self.map.addAnnotation(annotation)
        self.addAnnotations()
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: place.coordinate, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
