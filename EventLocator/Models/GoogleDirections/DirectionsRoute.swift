//
//  DirectionsRoute.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class DirectionsRoute : NSObject, NSCoding{

    var bounds : DirectionsBound!
    var copyrights : String!
    var legs : [DirectionsLeg]!
    var overviewPolyline : DirectionsOverviewPolyline!
    var summary : String!
    var warnings : [String]!
    var waypointOrder : [AnyObject]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        copyrights = dictionary["copyrights"] as? String
        summary = dictionary["summary"] as? String
        if let boundsData = dictionary["bounds"] as? [String:Any]{
            bounds = DirectionsBound(fromDictionary: boundsData)
        }
        if let overviewPolylineData = dictionary["overview_polyline"] as? [String:Any]{
            overviewPolyline = DirectionsOverviewPolyline(fromDictionary: overviewPolylineData)
        }
        legs = [DirectionsLeg]()
        if let legsArray = dictionary["legs"] as? [[String:Any]]{
            for dic in legsArray{
                let value = DirectionsLeg(fromDictionary: dic)
                legs.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if copyrights != nil{
            dictionary["copyrights"] = copyrights
        }
        if summary != nil{
            dictionary["summary"] = summary
        }
        if bounds != nil{
            dictionary["bounds"] = bounds.toDictionary()
        }
        if overviewPolyline != nil{
            dictionary["overviewPolyline"] = overviewPolyline.toDictionary()
        }
        if legs != nil{
            var dictionaryElements = [[String:Any]]()
            for legsElement in legs {
                dictionaryElements.append(legsElement.toDictionary())
            }
            dictionary["legs"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        bounds = aDecoder.decodeObject(forKey: "bounds") as? DirectionsBound
        copyrights = aDecoder.decodeObject(forKey: "copyrights") as? String
        legs = aDecoder.decodeObject(forKey: "legs") as? [DirectionsLeg]
        overviewPolyline = aDecoder.decodeObject(forKey: "overview_polyline") as? DirectionsOverviewPolyline
        summary = aDecoder.decodeObject(forKey: "summary") as? String
        warnings = aDecoder.decodeObject(forKey: "warnings") as? [String]
        waypointOrder = aDecoder.decodeObject(forKey: "waypoint_order") as? [AnyObject]
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
        if copyrights != nil{
            aCoder.encode(copyrights, forKey: "copyrights")
        }
        if legs != nil{
            aCoder.encode(legs, forKey: "legs")
        }
        if overviewPolyline != nil{
            aCoder.encode(overviewPolyline, forKey: "overview_polyline")
        }
        if summary != nil{
            aCoder.encode(summary, forKey: "summary")
        }
        if warnings != nil{
            aCoder.encode(warnings, forKey: "warnings")
        }
        if waypointOrder != nil{
            aCoder.encode(waypointOrder, forKey: "waypoint_order")
        }
    }
}