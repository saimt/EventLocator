//
//  ApiManager.swift
//  EventLocator
//
//  Created by Saim on 24/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Alamofire
import CoreLocation
public class ApiManager {
    
    static let usersPath = Database.database().reference().child(Constants.registeredUsers)
    static let eventsPath = Database.database().reference().child(Constants.events)
    static let storagePath = Storage.storage().reference().child(Constants.pictures)
    
    static func getGeocodeData(latitude: Double, longitude: Double ,completion: @escaping(Any)->Void) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(Constants.GMaps_API_Key)"
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200: //success
                        //to get JSON return value
                        if let result = response.result.value {
                            let jdict = result as! NSDictionary
                            completion(jdict)
                        }
                        
                    default:
                        if let result = response.result.value {
                            let jdict = result as! NSDictionary
                            completion(jdict)
                        }
                        else{
                            completion("Failed")
                        }
                    }
                } else {
                    print((response.error?.localizedDescription)!)
                    
                }
        }
    }
    
    static func createUser(_ userId: String,_ userDevice: String) {
        usersPath.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSDictionary {
                
            }
            else {
                let userData = [Constants.userId: userId, Constants.deviceType: userDevice, Constants.showEndedEvents: true, Constants.userRadius: 2] as [String : Any]
                usersPath.child(userId).updateChildValues(userData)
                Global.userData = UserMapper(fromDictionary: userData)
                //#CACHE#
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.userData)
                UserDefaults.standard.set(encodedData, forKey: Constants.registeredUsers)
                UserDefaults.standard.synchronize()
            }
            getUserData(userID: userId)
        }
        
        
    }
    
    static func getUserData(userID: String) {
        usersPath.child(userID).observe(DataEventType.value) { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                Global.userData = UserMapper(fromDictionary: data as! [String : Any])
            }
        }
    }
    
    static func updateUserData() {
        usersPath.child(Global.userData.userId).updateChildValues(Global.userData.toDictionary())
        //#CACHE#
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.userData)
        UserDefaults.standard.set(encodedData, forKey: Constants.registeredUsers)
        UserDefaults.standard.synchronize()
    }
    
    
    static func uploadEventPicture(event: EventMapper, picture: UIImage, completion: @escaping(PictureMapper?, Error?)->Void) {
        let pictureId = eventsPath.childByAutoId().key
        let time = Double(Date().currentTimeMillis())
        self.uploadHighQualityPicture(picture: picture, eventId: event.eventId) { (highQuality, lowQuality, error)  in
            if error == nil {
                let pictureData = [Constants.pictureId: pictureId!, Constants.pictureUrl: highQuality, Constants.pictureThumbnailUrl: lowQuality, Constants.pictureTime: time] as [String : Any]
                let pictureMapper = PictureMapper(fromDictionary: pictureData)
                eventsPath.child(event.eventId).child(Constants.pictures).child(pictureId!).setValue(pictureMapper.toDictionary())
                completion(pictureMapper, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    static func createEvent(event: EventMapper, coverPhoto: UIImage, completion: @escaping(String, Error?)->Void) {
        let eventId = eventsPath.childByAutoId().key
        event.eventId = eventId
        self.uploadHighQualityPicture(picture: coverPhoto, eventId: eventId!) { (highQuality, lowQuality, error)  in
            if error == nil {
                event.eventCoverUrl = highQuality
                event.eventCoverThumbnailUrl = lowQuality
                eventsPath.child(eventId!).setValue(event.toDictionary())
                completion("success", nil)
            }
            else {
                completion("", error)
            }
        }
    }
    
    static func uploadHighQualityPicture(picture: UIImage, eventId: String, completion: @escaping(String, String, Error?)->Void) {
        let imageData = picture.jpegData(compressionQuality: 0.8)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let timestampString = "\(eventId)_\(Date().currentTimeMillis())"
        let storageRef = storagePath.child(eventId).child(timestampString)
        storageRef.putData(imageData!, metadata: metadata) { (data, error) in
            if error == nil {
                var pictureUrl = ""
                storageRef.downloadURL { (url, error) in
                    pictureUrl = url!.absoluteString
                    self.uploadLowQualityPicture(picture: picture, eventId: eventId) { (url, error) in
                        if error == nil {
                            completion(pictureUrl, url, nil)
                        }
                    }
                }
            }
        }
    }
    
    static func uploadLowQualityPicture(picture: UIImage, eventId: String, completion: @escaping(String,Error?)->Void) {
        let imageData = picture.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let timestampString = "\(eventId)_\(Date().currentTimeMillis())"
        let storageRef = storagePath.child(eventId).child(timestampString)
        storageRef.putData(imageData!, metadata: metadata) { (data, error) in
            if error == nil {
                var pictureUrl = ""
                storageRef.downloadURL { (url, error) in
                    pictureUrl = url!.absoluteString
                    completion(pictureUrl, nil)
                }
                
            }
            else {
                completion("", error)
            }
        }
    }
    
    
    public static func getNearbyEvents(completion: @escaping(String?)->Void) {
        eventsPath.observe(DataEventType.value) { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                let keys = data.allKeys
                Global.eventsData = []
                for key in keys {
                    let dict = data[key] as! NSDictionary
                    let eventData = EventMapper(fromDictionary: data[key] as! [String : Any])
                    
                    //checking if event time has ended or not
                    if !(Global.userData?.showEndedEvents ?? true) {
                        if eventData.eventEnd < Double(Date().currentTimeMillis()) {
                            continue
                        }
                    }
                    
                    //checking if event location is in user's search area
                    let distance = Global.userData.userLocation.calculateDistance(eventLocation: eventData.eventLocation)
                    let distanceInKilometres = Double(distance/1000)
                    if distanceInKilometres > Double(Global.userData.userRadius) {
                        continue
                    }
                    
                    if let pictureDict = dict[Constants.pictures] as? NSDictionary {
                        let pictureKeys = pictureDict.allKeys
                        for picture in pictureKeys {
                            let pictureData = PictureMapper(fromDictionary: pictureDict[picture] as! [String : Any])
                            eventData.pictures.append(pictureData)
                        }
                    }
                    
                    Global.eventsData.append(eventData)
                    //#CACHE#
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: Global.eventsData)
                    UserDefaults.standard.set(encodedData, forKey: Constants.events)
                    UserDefaults.standard.synchronize()
                }
                completion("success")
            }
        }
    }
    
    public static func getDirections(origin: String, destination: String, mode: String, completionHandler:
    @escaping
     (Any?, Error?) -> ()) {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(mode)&key=\(Constants.GMaps_API_Key)"
            
            // print("googleDirectionAPI URL: ", url)
            
            Alamofire.request(url).validate().responseJSON { response in
                
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200: //success
                        //to get JSON return value
                        if let result = response.result.value {
                            let jdict = result as! NSDictionary
                            completionHandler(jdict, nil)
                        }
                        
                    default:
                        let error = response.result.error
                        completionHandler(nil, error)
                    }
                    
                } else {
                    let error = response.result.error
                    completionHandler(nil, error)
                }
            }
        }
    
}


