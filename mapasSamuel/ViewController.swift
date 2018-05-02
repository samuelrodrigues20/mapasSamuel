//
//  ViewController.swift
//  mapasSamuel
//
//  Created by DocAdmin on 4/27/18.
//  Copyright © 2018 estg.ipvc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,  MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //foco num ponto
        let initialLocation = CLLocation(latitude: 41.701497, longitude: -8.834756)
        centerMapOnLocation(location: initialLocation)
        
        let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        let longPressedRecognized = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        mapView.addGestureRecognizer(tapGesture)
        mapView.addGestureRecognizer(longPressedRecognized)
        
        
        
    }
    
    // MARK: eventos mapa
    
    func tapped(_ sender:UITapGestureRecognizer){
    print("tapped")
    }
    
    func longPressed(_ sender: UILongPressGestureRecognizer){
    
        if sender.state.rawValue == 1{
        print("long tap")
            /*        let touchLocation = sender.location(in: mapView)
            let locationCoordinate  = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            print("Long Tapped at lat:\(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            // geocode location
            geocoder.reverseGeocodeLocation(location) {  (placemarks, error) in
             self.processResponseRev(withPlacemarks: placemarks, error: error)
                
                
            }
*/
        }
    
       }

    func centerMapOnLocation(location : CLLocation){
        
        
        let regionRadius: CLLocationDistance = 2000 // metros
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        // anotacoes
        
        let point = MKPointAnnotation();
        point.coordinate = CLLocationCoordinate2D(latitude: 41.701497, longitude: -8.834756)
        point.title = "Santa Luzia"
        point.subtitle = "Viana do Castelo"
        mapView.addAnnotation(point);
    
    }
    
    // MARK: proprietes
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textGeo: UITextField!
    @IBOutlet weak var labelGeo: UILabel!
    
    var geocoder = CLGeocoder()
    
    //MARK: actions
    
    
    @IBAction func clickSegControl(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    //MARK: geocoding
    
    
    @IBAction func butGeocoding(_ sender: Any) {
        
        // Geocode Address String 
        geocoder.geocodeAddressString(textGeo.text!) {
            (placemarks, error) in self.processResponse(withPlacemarks: placemarks, error: error)
        	}
    
        
    }
    private func processResponse(withPlacemarks placemarks :[CLPlacemark]?, error: Error? ){
    
        if let error = error {
            print("aaa")
            labelGeo.text = "Nao foi possivel encontrar a morada"
        
        
        }
        else{
            var location :CLLocation?
            if let placemarks = placemarks, placemarks.count>0{
            location = placemarks.first?.location
            }
            if let location = location{
            let coordinate = location.coordinate
                labelGeo.text="\(coordinate.latitude),\(coordinate.longitude)"
            centerMapOnLocation(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                )
            
        
        
        }else{
            
                labelGeo.text = "nao foi possivel encontrar o endereco"
                    
                }
                
            }
        }
    
    private func processResponceRev(withPlacemarks placemarks : [CLPlacemark]?, error: Error?){
    
    if let error = error {
    print("Unable to Reverse geocoding  Location(\(error))")
    labelGeo.text="unable to find  address for location"
        
    
    }
    else{
        if let placemarks  = placemarks, let placemark = placemarks.first{
        labelGeo.text = "\(placemark.country!) - \(placemark.locality!)  - \(placemark.postalCode!) - \(placemark.name!)"
        }
        else {
        labelGeo.text = "no matching adress founfing"
            
        }
        
        }
    
    
    
    }
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control : UIControl ) {
        if control == view.rightCalloutAccessoryView{
        print(view.annotation!.title!!)
        print(view.annotation!.subtitle!!)
        print(view.annotation!.coordinate)
            
        }
    }
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        let reuseId =  "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        
        
        
        if pinView == nil{
         pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            
        }
        let button  = UIButton(type: .detailDisclosure) as UIButton
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

