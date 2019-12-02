//
//  GecoderViewport.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class GecoderViewport : NSObject, NSCoding{

    var northeast : GecoderNortheast!
    var southwest : GecoderSouthwest!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let northeastData = dictionary["northeast"] as? [String:Any]{
            northeast = GecoderNortheast(fromDictionary: northeastData)
        }
        if let southwestData = dictionary["southwest"] as? [String:Any]{
            southwest = GecoderSouthwest(fromDictionary: southwestData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if northeast != nil{
            dictionary["northeast"] = northeast.toDictionary()
        }
        if southwest != nil{
            dictionary["southwest"] = southwest.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        northeast = aDecoder.decodeObject(forKey: "northeast") as? GecoderNortheast
        southwest = aDecoder.decodeObject(forKey: "southwest") as? GecoderSouthwest
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if northeast != nil{
            aCoder.encode(northeast, forKey: "northeast")
        }
        if southwest != nil{
            aCoder.encode(southwest, forKey: "southwest")
        }
    }
}