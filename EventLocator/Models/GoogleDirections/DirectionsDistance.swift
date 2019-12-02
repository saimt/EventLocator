//
//  DirectionsDistance.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class DirectionsDistance : NSObject, NSCoding{

    var text : String!
    var value : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        text = dictionary["text"] as? String
        value = dictionary["value"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if text != nil{
            dictionary["text"] = text
        }
        if value != nil{
            dictionary["value"] = value
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        text = aDecoder.decodeObject(forKey: "text") as? String
        value = aDecoder.decodeObject(forKey: "value") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if text != nil{
            aCoder.encode(text, forKey: "text")
        }
        if value != nil{
            aCoder.encode(value, forKey: "value")
        }
    }
}