//
//  ViewController.swift
//  AppStudTest
//
//  Created by hassine othmane on 12/13/17.
//  Copyright © 2017 hassine othmane. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController  {

    let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var mapView : GMSMapView!
    fileprivate let presenter = MapPresenter(mapServices: MapServices())


    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self) // presenter

        // init mapView
        let camera = GMSCameraPosition.camera(withLatitude: 37.7721367, longitude: -122.410789, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView

        //get user location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestLocation()
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//GoogleMapLocation
extension ViewController:CLLocationManagerDelegate
{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = manager.location!.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 10)
        self.mapView.camera = camera
        presenter.getNearbyPlaces(lat:String( location.latitude), lng: String(location.longitude))

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
         presenter.getNearbyPlaces(lat: "37.7721367", lng: "-122.410789")
    }

}

//MapView
extension ViewController:MapView
{

    func setEmptyResult() {
        let alert = UIAlertController(title: "Alert", message: "empty", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func setNearbyPlaces(_ locations: [LocationDetail]) {

        print(locations)
        for bar in locations
        {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(bar.lat), longitude: CLLocationDegrees(bar.lng))
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=50&photoreference=\(bar.refImage)&key=AIzaSyDX94XsmOraY4X3puvQAh_UY1QnQE7KCP4"), placeholderImage: nil)
           DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            marker.icon = imageView.image
            marker.map = self.mapView
           })

        }
    }
}






