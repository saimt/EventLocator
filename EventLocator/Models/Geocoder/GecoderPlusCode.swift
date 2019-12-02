//
//  GecoderPlusCode.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class GecoderPlusCode : NSObject, NSCoding{

    var compoundCode : String!
    var globalCode : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        compoundCode = dictionary["compound_code"] as? String
        globalCode = dictionary["global_code"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if compoundCode != nil{
            dictionary["compound_code"] = compoundCode
        }
        if globalCode != nil{
            dictionary["global_code"] = globalCode
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        compoundCode = aDecoder.decodeObject(forKey: "compound_code") as? String
        globalCode = aDecoder.decodeObject(forKey: "global_code") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if compoundCode != nil{
            aCoder.encode(compoundCode, forKey: "compound_code")
        }
        if globalCode != nil{
            aCoder.encode(globalCode, forKey: "global_code")
        }
    }
}