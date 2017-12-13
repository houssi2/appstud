//
//  MapPresenter.swift
//  AppStudTest
//
//  Created by hassine othmane on 12/13/17.
//  Copyright © 2017 hassine othmane. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MapView: NSObjectProtocol {
    func setNearbyPlaces(_ locations: [LocationDetail])
    func setEmptyResult()
}



class MapPresenter {
fileprivate let mapServices:MapServices
weak fileprivate var mapView : MapView?

init(mapServices:MapServices){
    self.mapServices = mapServices
}

func attachView(_ view:MapView){
    mapView = view
}

func detachView() {
    mapView = nil
}


    func getNearbyPlaces(lat : String , lng : String){
    mapServices.getNearbyPlaces(lat: lat, lng:  lng){ [weak self] locations in

        if(locations.count == 0){
                 self?.mapView?.setEmptyResult()
        }else{

            let mappedLocations = locations.enumerated().map({ (index,element) -> LocationDetail in

                var lat : Float  = 0.0
                var lng  : Float = 0.0
                var photoReference = ""
                var json = JSON(element)
                if let resDataLocation = json["geometry"].dictionaryObject {
                    var res = resDataLocation as! [String:AnyObject]
                    lat = res["location"]!["lat"]! as! Float
                    lng = res["location"]!["lng"]! as! Float
                }

                if let resDataPhoto = json["photos"].arrayObject {
                    var res = resDataPhoto as! [[String:AnyObject]]
                     photoReference = res[0]["photo_reference"]! as! String
                }
                return LocationDetail(name: element["name"] as! String,lat:lat, lng: lng, refImage: photoReference)

            })
            self?.mapView?.setNearbyPlaces(mappedLocations)
        }
    }
}
}
