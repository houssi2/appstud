//
//  MapServices.swift
//  AppStudTest
//
//  Created by hassine othmane on 12/13/17.
//  Copyright © 2017 hassine othmane. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MapServices {
    func getNearbyPlaces(lat : String, lng : String, _ callBack:@escaping ([[String:AnyObject]]) -> Void){
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=20000&type=bar&keyword=cruise&key=AIzaSyDX94XsmOraY4X3puvQAh_UY1QnQE7KCP4").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                if let resData = json["results"].arrayObject {
                    var arrRes = resData as! [[String:AnyObject]]
                    callBack(arrRes)
                }

            }
        }
    }
}
