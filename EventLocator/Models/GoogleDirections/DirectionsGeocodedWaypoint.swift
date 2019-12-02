//
//  DirectionsGeocodedWaypoint.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class DirectionsGeocodedWaypoint : NSObject, NSCoding{

    var geocoderStatus : String!
    var placeId : String!
    var types : [String]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        geocoderStatus = dictionary["geocoder_status"] as? String
        placeId = dictionary["place_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if geocoderStatus != nil{
            dictionary["geocoder_status"] = geocoderStatus
        }
        if placeId != nil{
            dictionary["place_id"] = placeId
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        geocoderStatus = aDecoder.decodeObject(forKey: "geocoder_status") as? String
        placeId = aDecoder.decodeObject(forKey: "place_id") as? String
        types = aDecoder.decodeObject(forKey: "types") as? [String]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if geocoderStatus != nil{
            aCoder.encode(geocoderStatus, forKey: "geocoder_status")
        }
        if placeId != nil{
            aCoder.encode(placeId, forKey: "place_id")
        }
        if types != nil{
            aCoder.encode(types, forKey: "types")
        }
    }
}