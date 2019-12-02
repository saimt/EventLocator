//
//  GecoderGeometry.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class GecoderGeometry : NSObject, NSCoding{

    var bounds : GecoderBound!
    var location : GecoderLocation!
    var locationType : String!
    var viewport : GecoderViewport!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        locationType = dictionary["location_type"] as? String
        if let boundsData = dictionary["bounds"] as? [String:Any]{
            bounds = GecoderBound(fromDictionary: boundsData)
        }
        if let locationData = dictionary["location"] as? [String:Any]{
            location = GecoderLocation(fromDictionary: locationData)
        }
        if let viewportData = dictionary["viewport"] as? [String:Any]{
            viewport = GecoderViewport(fromDictionary: viewportData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if locationType != nil{
            dictionary["location_type"] = locationType
        }
        if bounds != nil{
            dictionary["bounds"] = bounds.toDictionary()
        }
        if location != nil{
            dictionary["location"] = location.toDictionary()
        }
        if viewport != nil{
            dictionary["viewport"] = viewport.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        bounds = aDecoder.decodeObject(forKey: "bounds") as? GecoderBound
        location = aDecoder.decodeObject(forKey: "location") as? GecoderLocation
        locationType = aDecoder.decodeObject(forKey: "location_type") as? String
        viewport = aDecoder.decodeObject(forKey: "viewport") as? GecoderViewport
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if bounds != nil{
            aCoder.encode(bounds, forKey: "bounds")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if locationType != nil{
            aCoder.encode(locationType, forKey: "location_type")
        }
        if viewport != nil{
            aCoder.encode(viewport, forKey: "viewport")
        }
    }
}