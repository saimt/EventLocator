//
//  DirectionsLeg.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class DirectionsLeg : NSObject, NSCoding{

    var distance : DirectionsDistance!
    var duration : DirectionsDuration!
    var endAddress : String!
    var endLocation : DirectionsEndLocation!
    var startAddress : String!
    var startLocation : DirectionsStartLocation!
    var steps : [DirectionsStep]!
    var trafficSpeedEntry : [AnyObject]!
    var viaWaypoint : [AnyObject]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        endAddress = dictionary["end_address"] as? String
        startAddress = dictionary["start_address"] as? String
        if let distanceData = dictionary["distance"] as? [String:Any]{
            distance = DirectionsDistance(fromDictionary: distanceData)
        }
        if let durationData = dictionary["duration"] as? [String:Any]{
            duration = DirectionsDuration(fromDictionary: durationData)
        }
        if let endLocationData = dictionary["end_location"] as? [String:Any]{
            endLocation = DirectionsEndLocation(fromDictionary: endLocationData)
        }
        if let startLocationData = dictionary["start_location"] as? [String:Any]{
            startLocation = DirectionsStartLocation(fromDictionary: startLocationData)
        }
        steps = [DirectionsStep]()
        if let stepsArray = dictionary["steps"] as? [[String:Any]]{
            for dic in stepsArray{
                let value = DirectionsStep(fromDictionary: dic)
                steps.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if endAddress != nil{
            dictionary["end_address"] = endAddress
        }
        if startAddress != nil{
            dictionary["start_address"] = startAddress
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
        if startLocation != nil{
            dictionary["startLocation"] = startLocation.toDictionary()
        }
        if steps != nil{
            var dictionaryElements = [[String:Any]]()
            for stepsElement in steps {
                dictionaryElements.append(stepsElement.toDictionary())
            }
            dictionary["steps"] = dictionaryElements
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
        endAddress = aDecoder.decodeObject(forKey: "end_address") as? String
        endLocation = aDecoder.decodeObject(forKey: "end_location") as? DirectionsEndLocation
        startAddress = aDecoder.decodeObject(forKey: "start_address") as? String
        startLocation = aDecoder.decodeObject(forKey: "start_location") as? DirectionsStartLocation
        steps = aDecoder.decodeObject(forKey: "steps") as? [DirectionsStep]
        trafficSpeedEntry = aDecoder.decodeObject(forKey: "traffic_speed_entry") as? [AnyObject]
        viaWaypoint = aDecoder.decodeObject(forKey: "via_waypoint") as? [AnyObject]
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
        if endAddress != nil{
            aCoder.encode(endAddress, forKey: "end_address")
        }
        if endLocation != nil{
            aCoder.encode(endLocation, forKey: "end_location")
        }
        if startAddress != nil{
            aCoder.encode(startAddress, forKey: "start_address")
        }
        if startLocation != nil{
            aCoder.encode(startLocation, forKey: "start_location")
        }
        if steps != nil{
            aCoder.encode(steps, forKey: "steps")
        }
        if trafficSpeedEntry != nil{
            aCoder.encode(trafficSpeedEntry, forKey: "traffic_speed_entry")
        }
        if viaWaypoint != nil{
            aCoder.encode(viaWaypoint, forKey: "via_waypoint")
        }
    }
}