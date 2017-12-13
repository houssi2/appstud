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

    init() {

    }


    func getNearbyPlaces(lat : String, lng : String, _ callBack:@escaping ([[String:AnyObject]]) -> Void){
        var arrRes =  [[String:AnyObject]]()

        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=20000&type=bar&keyword=cruise&key=AIzaSyDX94XsmOraY4X3puvQAh_UY1QnQE7KCP4").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {





                let swiftyJsonVar = JSON(responseData.result.value!)
            //    let arrayNames =  swiftyJsonVar["results"].arrayValue.map({$0["name"].stringValue})


                if let resData = swiftyJsonVar["results"].arrayObject {
                    arrRes = resData as! [[String:AnyObject]]

                }
                
                callBack(arrRes)
            }
        }





    }

}
