//
//  EventMapper.swift
//  EventLocator
//
//  Created by Saim on 27/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import Foundation


class UserMapper : NSObject, NSCoding{

    var userId : String!
    var userDevice : String!
    var userLocation : String!
    var userRadius : Float!
    var showEndedEvents: Bool!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        userId = dictionary[Constants.userId] as? String
        userDevice = dictionary[Constants.deviceType] as? String
        userLocation = dictionary[Constants.userLocation] as? String
        userRadius = dictionary[Constants.userRadius] as? Float
        showEndedEvents = dictionary[Constants.showEndedEvents] as? Bool
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if userId != nil{
            dictionary[Constants.userId] = userId
        }
        if userDevice != nil{
            dictionary[Constants.deviceType] = userDevice
        }
        if userLocation != nil{
            dictionary[Constants.userLocation] = userLocation
        }
        if userRadius != nil{
            dictionary[Constants.userRadius] = userRadius
        }
        if showEndedEvents != nil{
            dictionary[Constants.showEndedEvents] = showEndedEvents
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        userId = aDecoder.decodeObject(forKey: Constants.userId) as? String
        userDevice = aDecoder.decodeObject(forKey: Constants.deviceType) as? String
        userLocation = aDecoder.decodeObject(forKey: Constants.userLocation) as? String
        userRadius = aDecoder.decodeObject(forKey: Constants.userRadius) as? Float
        showEndedEvents = aDecoder.decodeObject(forKey: Constants.showEndedEvents) as? Bool
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if userId != nil{
            aCoder.encode(userId, forKey: Constants.userId)
        }
        if userDevice != nil{
            aCoder.encode(userDevice, forKey: Constants.deviceType)
        }
        if userLocation != nil{
            aCoder.encode(userLocation, forKey: Constants.userLocation)
        }
        if userRadius != nil{
            aCoder.encode(userRadius, forKey: Constants.userRadius)
        }
        if showEndedEvents != nil{
            aCoder.encode(showEndedEvents, forKey: Constants.showEndedEvents)
        }
    }
}
