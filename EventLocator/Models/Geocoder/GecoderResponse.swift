//
//  GecoderResponse.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class GecoderResponse : NSObject, NSCoding{

    var plusCode : GecoderPlusCode!
    var results : [GecoderResult]!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        status = dictionary["status"] as? String
        if let plusCodeData = dictionary["plus_code"] as? [String:Any]{
            plusCode = GecoderPlusCode(fromDictionary: plusCodeData)
        }
        results = [GecoderResult]()
        if let resultsArray = dictionary["results"] as? [[String:Any]]{
            for dic in resultsArray{
                let value = GecoderResult(fromDictionary: dic)
                results.append(value)
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
        if plusCode != nil{
            dictionary["plusCode"] = plusCode.toDictionary()
        }
        if results != nil{
            var dictionaryElements = [[String:Any]]()
            for resultsElement in results {
                dictionaryElements.append(resultsElement.toDictionary())
            }
            dictionary["results"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        plusCode = aDecoder.decodeObject(forKey: "plus_code") as? GecoderPlusCode
        results = aDecoder.decodeObject(forKey: "results") as? [GecoderResult]
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if plusCode != nil{
            aCoder.encode(plusCode, forKey: "plus_code")
        }
        if results != nil{
            aCoder.encode(results, forKey: "results")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
