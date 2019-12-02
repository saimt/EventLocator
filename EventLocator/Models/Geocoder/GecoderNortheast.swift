//
//  GecoderNortheast.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class GecoderNortheast : NSObject, NSCoding{

    var lat : Float!
    var lng : Float!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        lat = dictionary["lat"] as? Float
        lng = dictionary["lng"] as? Float
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        lat = aDecoder.decodeObject(forKey: "lat") as? Float
        lng = aDecoder.decodeObject(forKey: "lng") as? Float
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
    }
}