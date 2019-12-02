//
//  GecoderAddressComponent.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class GecoderAddressComponent : NSObject, NSCoding{

    var longName : String!
    var shortName : String!
    var types : [String]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        longName = dictionary["long_name"] as? String
        shortName = dictionary["short_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if longName != nil{
            dictionary["long_name"] = longName
        }
        if shortName != nil{
            dictionary["short_name"] = shortName
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        longName = aDecoder.decodeObject(forKey: "long_name") as? String
        shortName = aDecoder.decodeObject(forKey: "short_name") as? String
        types = aDecoder.decodeObject(forKey: "types") as? [String]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if longName != nil{
            aCoder.encode(longName, forKey: "long_name")
        }
        if shortName != nil{
            aCoder.encode(shortName, forKey: "short_name")
        }
        if types != nil{
            aCoder.encode(types, forKey: "types")
        }
    }
}