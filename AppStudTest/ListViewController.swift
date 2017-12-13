//
//  ListViewController.swift
//  AppStudTest
//
//  Created by hassine othmane on 12/13/17.
//  Copyright © 2017 hassine othmane. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps

class ListViewController: UIViewController {

    var bars = [LocationDetail]()
     let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D(latitude: 37.7721367, longitude: -122.410789)
    @IBOutlet weak var tableView: UITableView?
    fileprivate let presenter = ListPresenter(mapServices: MapServices())

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)// presnter methode

        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestLocation()
        }

        var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                #selector(ListViewController.handleRefresh(_:)),
                                     for: UIControlEvents.valueChanged)
            refreshControl.tintColor = UIColor.red

            return refreshControl
        }()
        tableView?.addSubview(refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter.getNearbyPlaces(lat:String( location.latitude), lng: String(location.longitude))
        refreshControl.endRefreshing()

    }



}


//GoogleMapLocation
extension ListViewController:CLLocationManagerDelegate
{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         location = manager.location!.coordinate
        presenter.getNearbyPlaces(lat:String( location.latitude), lng: String(location.longitude))

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
        presenter.getNearbyPlaces(lat: "37.7721367", lng: "-122.410789")
    }
    
}

//extension : UITableViewDataSource
extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bars.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! BarTableViewCell
        var refImage = bars[(indexPath as NSIndexPath).row].refImage
        cell.img.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(Int(tableView.frame.width))&photoreference=\(refImage)&key=AIzaSyDX94XsmOraY4X3puvQAh_UY1QnQE7KCP4"), placeholderImage: nil)
        cell.label.text = bars[(indexPath as NSIndexPath).row].name
        return cell

    }
}

//extension : TripView
extension ListViewController: ListView {
    
    func setEmptyResult() {
        let alert = UIAlertController(title: "Alert", message: "empty", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    func setBars(_ bars: [LocationDetail]) {
        self.bars = bars
        tableView?.reloadData()

    }
}


