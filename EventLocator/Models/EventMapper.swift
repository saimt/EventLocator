//
//  EventMapper.swift
//  EventLocator
//
//  Created by Saim on 27/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import Foundation


class EventMapper : NSObject, NSCoding{

    var eventName : String!
    var eventId : String!
    var eventStart : Double!
    var eventEnd : Double!
    var eventLocation : String!
    var eventCoverUrl : String!
    var eventCoverThumbnailUrl : String!
    var pictures: [PictureMapper]!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        eventName = dictionary[Constants.eventName] as? String
        eventId = dictionary[Constants.eventId] as? String
        eventStart = dictionary[Constants.eventStart] as? Double
        eventEnd = dictionary[Constants.eventEnd] as? Double
        eventLocation = dictionary[Constants.eventLocation] as? String
        eventCoverUrl = dictionary[Constants.eventCoverUrl] as? String
        eventCoverThumbnailUrl = dictionary[Constants.eventCoverThumbnailUrl] as? String
        pictures = [PictureMapper]()
        if let picturesArray = dictionary[Constants.pictures] as? [[String:Any]]{
            for dic in picturesArray{
                let value = PictureMapper(fromDictionary: dic)
                pictures.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if eventName != nil{
            dictionary[Constants.eventName] = eventName
        }
        if eventId != nil{
            dictionary[Constants.eventId] = eventId
        }
        if eventStart != nil{
            dictionary[Constants.eventStart] = eventStart
        }
        if eventEnd != nil{
            dictionary[Constants.eventEnd] = eventEnd
        }
        if eventLocation != nil{
            dictionary[Constants.eventLocation] = eventLocation
        }
        if eventCoverUrl != nil{
            dictionary[Constants.eventCoverUrl] = eventCoverUrl
        }
        if eventCoverThumbnailUrl != nil{
            dictionary[Constants.eventCoverThumbnailUrl] = eventCoverThumbnailUrl
        }
        if pictures != nil{
            var dictionaryElements = [[String:Any]]()
            for pictureElement in pictures {
                dictionaryElements.append(pictureElement.toDictionary())
            }
            dictionary[Constants.pictures] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        eventName = aDecoder.decodeObject(forKey: Constants.eventName) as? String
        eventId = aDecoder.decodeObject(forKey: Constants.eventId) as? String
        eventStart = aDecoder.decodeObject(forKey: Constants.eventStart) as? Double
        eventEnd = aDecoder.decodeObject(forKey: Constants.eventEnd) as? Double
        eventLocation = aDecoder.decodeObject(forKey: Constants.eventLocation) as? String
        eventCoverUrl = aDecoder.decodeObject(forKey: Constants.eventCoverUrl) as? String
        eventCoverThumbnailUrl = aDecoder.decodeObject(forKey: Constants.eventCoverThumbnailUrl) as? String
        pictures = aDecoder.decodeObject(forKey: Constants.pictures) as? [PictureMapper]
    }
    
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if eventName != nil{
            aCoder.encode(eventName, forKey: Constants.eventName)
        }
        if eventId != nil{
            aCoder.encode(eventId, forKey: Constants.eventId)
        }
        if eventStart != nil{
            aCoder.encode(eventStart, forKey: Constants.eventStart)
        }
        if eventEnd != nil{
            aCoder.encode(eventEnd, forKey: Constants.eventEnd)
        }
        if eventLocation != nil{
            aCoder.encode(eventLocation, forKey: Constants.eventLocation)
        }
        if eventCoverUrl != nil{
            aCoder.encode(eventCoverUrl, forKey: Constants.eventCoverUrl)
        }
        if eventCoverThumbnailUrl != nil{
            aCoder.encode(eventCoverThumbnailUrl, forKey: Constants.eventCoverThumbnailUrl)
        }
        if pictures != nil{
            aCoder.encode(pictures, forKey: Constants.pictures)
        }
    }
}
