//
//  GecoderResult.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation


class GecoderResult : NSObject, NSCoding{

    var addressComponents : [GecoderAddressComponent]!
    var formattedAddress : String!
    var geometry : GecoderGeometry!
    var placeId : String!
    var plusCode : GecoderPlusCode!
    var types : [String]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        formattedAddress = dictionary["formatted_address"] as? String
        placeId = dictionary["place_id"] as? String
        if let geometryData = dictionary["geometry"] as? [String:Any]{
            geometry = GecoderGeometry(fromDictionary: geometryData)
        }
        if let plusCodeData = dictionary["plus_code"] as? [String:Any]{
            plusCode = GecoderPlusCode(fromDictionary: plusCodeData)
        }
        addressComponents = [GecoderAddressComponent]()
        if let addressComponentsArray = dictionary["address_components"] as? [[String:Any]]{
            for dic in addressComponentsArray{
                let value = GecoderAddressComponent(fromDictionary: dic)
                addressComponents.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if formattedAddress != nil{
            dictionary["formatted_address"] = formattedAddress
        }
        if placeId != nil{
            dictionary["place_id"] = placeId
        }
        if geometry != nil{
            dictionary["geometry"] = geometry.toDictionary()
        }
        if plusCode != nil{
            dictionary["plusCode"] = plusCode.toDictionary()
        }
        if addressComponents != nil{
            var dictionaryElements = [[String:Any]]()
            for addressComponentsElement in addressComponents {
                dictionaryElements.append(addressComponentsElement.toDictionary())
            }
            dictionary["addressComponents"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        addressComponents = aDecoder.decodeObject(forKey: "address_components") as? [GecoderAddressComponent]
        formattedAddress = aDecoder.decodeObject(forKey: "formatted_address") as? String
        geometry = aDecoder.decodeObject(forKey: "geometry") as? GecoderGeometry
        placeId = aDecoder.decodeObject(forKey: "place_id") as? String
        plusCode = aDecoder.decodeObject(forKey: "plus_code") as? GecoderPlusCode
        types = aDecoder.decodeObject(forKey: "types") as? [String]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if addressComponents != nil{
            aCoder.encode(addressComponents, forKey: "address_components")
        }
        if formattedAddress != nil{
            aCoder.encode(formattedAddress, forKey: "formatted_address")
        }
        if geometry != nil{
            aCoder.encode(geometry, forKey: "geometry")
        }
        if placeId != nil{
            aCoder.encode(placeId, forKey: "place_id")
        }
        if plusCode != nil{
            aCoder.encode(plusCode, forKey: "plus_code")
        }
        if types != nil{
            aCoder.encode(types, forKey: "types")
        }
    }
}