//
//  DirectionsResponse.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class DirectionsResponse : NSObject, NSCoding{

    var geocodedWaypoints : [DirectionsGeocodedWaypoint]!
    var routes : [DirectionsRoute]!
    var status : String!
    

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        status = dictionary["status"] as? String
        geocodedWaypoints = [DirectionsGeocodedWaypoint]()
        if let geocodedWaypointsArray = dictionary["geocoded_waypoints"] as? [[String:Any]]{
            for dic in geocodedWaypointsArray{
                let value = DirectionsGeocodedWaypoint(fromDictionary: dic)
                geocodedWaypoints.append(value)
            }
        }
        routes = [DirectionsRoute]()
        if let routesArray = dictionary["routes"] as? [[String:Any]]{
            for dic in routesArray{
                let value = DirectionsRoute(fromDictionary: dic)
                routes.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if status != nil{
            dictionary["status"] = status
        }
        if geocodedWaypoints != nil{
            var dictionaryElements = [[String:Any]]()
            for geocodedWaypointsElement in geocodedWaypoints {
                dictionaryElements.append(geocodedWaypointsElement.toDictionary())
            }
            dictionary["geocodedWaypoints"] = dictionaryElements
        }
        if routes != nil{
            var dictionaryElements = [[String:Any]]()
            for routesElement in routes {
                dictionaryElements.append(routesElement.toDictionary())
            }
            dictionary["routes"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        geocodedWaypoints = aDecoder.decodeObject(forKey: "geocoded_waypoints") as? [DirectionsGeocodedWaypoint]
        routes = aDecoder.decodeObject(forKey: "routes") as? [DirectionsRoute]
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if geocodedWaypoints != nil{
            aCoder.encode(geocodedWaypoints, forKey: "geocoded_waypoints")
        }
        if routes != nil{
            aCoder.encode(routes, forKey: "routes")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
