//
//  EventMapper.swift
//  EventLocator
//
//  Created by Saim on 27/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import Foundation


class PictureMapper : NSObject, NSCoding{

    var pictureId : String!
    var pictureUrl : String!
    var pictureThumbnailUrl : String!
    var pictureTime : Double!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        pictureId = dictionary[Constants.pictureId] as? String
        pictureUrl = dictionary[Constants.pictureUrl] as? String
        pictureThumbnailUrl = dictionary[Constants.pictureThumbnailUrl] as? String
        pictureTime = dictionary[Constants.pictureTime] as? Double
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if pictureId != nil{
            dictionary[Constants.pictureId] = pictureId
        }
        if pictureUrl != nil{
            dictionary[Constants.pictureUrl] = pictureUrl
        }
        if pictureThumbnailUrl != nil{
            dictionary[Constants.pictureThumbnailUrl] = pictureThumbnailUrl
        }
        if pictureTime != nil{
            dictionary[Constants.pictureTime] = pictureTime
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        pictureId = aDecoder.decodeObject(forKey: Constants.pictureId) as? String
        pictureUrl = aDecoder.decodeObject(forKey: Constants.pictureUrl) as? String
        pictureThumbnailUrl = aDecoder.decodeObject(forKey: Constants.pictureThumbnailUrl) as? String
        pictureTime = aDecoder.decodeObject(forKey: Constants.pictureTime) as? Double
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if pictureId != nil{
            aCoder.encode(pictureId, forKey: Constants.pictureId)
        }
        if pictureUrl != nil{
            aCoder.encode(pictureUrl, forKey: Constants.pictureUrl)
        }
        if pictureThumbnailUrl != nil{
            aCoder.encode(pictureThumbnailUrl, forKey: Constants.pictureThumbnailUrl)
        }
        if pictureTime != nil{
            aCoder.encode(pictureTime, forKey: Constants.pictureTime)
        }
    }
}
