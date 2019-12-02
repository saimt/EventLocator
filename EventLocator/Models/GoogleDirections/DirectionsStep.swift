//
//  DirectionsStep.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class DirectionsStep : NSObject, NSCoding{

    var distance : DirectionsDistance!
    var duration : DirectionsDuration!
    var endLocation : DirectionsEndLocation!
    var htmlInstructions : String!
    var maneuver : String!
    var polyline : DirectionsPolyline!
    var startLocation : DirectionsStartLocation!
    var travelMode : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        htmlInstructions = dictionary["html_instructions"] as? String
        maneuver = dictionary["maneuver"] as? String
        travelMode = dictionary["travel_mode"] as? String
        if let distanceData = dictionary["distance"] as? [String:Any]{
            distance = DirectionsDistance(fromDictionary: distanceData)
        }
        if let durationData = dictionary["duration"] as? [String:Any]{
            duration = DirectionsDuration(fromDictionary: durationData)
        }
        if let endLocationData = dictionary["end_location"] as? [String:Any]{
            endLocation = DirectionsEndLocation(fromDictionary: endLocationData)
        }
        if let polylineData = dictionary["polyline"] as? [String:Any]{
            polyline = DirectionsPolyline(fromDictionary: polylineData)
        }
        if let startLocationData = dictionary["start_location"] as? [String:Any]{
            startLocation = DirectionsStartLocation(fromDictionary: startLocationData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if htmlInstructions != nil{
            dictionary["html_instructions"] = htmlInstructions
        }
        if maneuver != nil{
            dictionary["maneuver"] = maneuver
        }
        if travelMode != nil{
            dictionary["travel_mode"] = travelMode
        }
        if distance != nil{
            dictionary["distance"] = distance.toDictionary()
        }
        if duration != nil{
            dictionary["duration"] = duration.toDictionary()
        }
        if endLocation != nil{
            dictionary["endLocation"] = endLocation.toDictionary()
        }
        if polyline != nil{
            dictionary["polyline"] = polyline.toDictionary()
        }
        if startLocation != nil{
            dictionary["startLocation"] = startLocation.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        distance = aDecoder.decodeObject(forKey: "distance") as? DirectionsDistance
        duration = aDecoder.decodeObject(forKey: "duration") as? DirectionsDuration
        endLocation = aDecoder.decodeObject(forKey: "end_location") as? DirectionsEndLocation
        htmlInstructions = aDecoder.decodeObject(forKey: "html_instructions") as? String
        maneuver = aDecoder.decodeObject(forKey: "maneuver") as? String
        polyline = aDecoder.decodeObject(forKey: "polyline") as? DirectionsPolyline
        startLocation = aDecoder.decodeObject(forKey: "start_location") as? DirectionsStartLocation
        travelMode = aDecoder.decodeObject(forKey: "travel_mode") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if duration != nil{
            aCoder.encode(duration, forKey: "duration")
        }
        if endLocation != nil{
            aCoder.encode(endLocation, forKey: "end_location")
        }
        if htmlInstructions != nil{
            aCoder.encode(htmlInstructions, forKey: "html_instructions")
        }
        if maneuver != nil{
            aCoder.encode(maneuver, forKey: "maneuver")
        }
        if polyline != nil{
            aCoder.encode(polyline, forKey: "polyline")
        }
        if startLocation != nil{
            aCoder.encode(startLocation, forKey: "start_location")
        }
        if travelMode != nil{
            aCoder.encode(travelMode, forKey: "travel_mode")
        }
    }
}