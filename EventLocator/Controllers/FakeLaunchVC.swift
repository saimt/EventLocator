//
//  FakeLaunchVC.swift
//  EventLocator
//
//  Created by Saim on 02/12/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotifications
import CoreLocation
class FakeLaunchVC: UIViewController {
    
    //MARK: Variables
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    //MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            self.notificationCenter.requestAuthorization(options: self.options) {
                (didAllow, error) in
                if !didAllow {
                    print("User has declined notifications")
                }
            }
          }
        }
        self.loadCache()
        
        //Delay to show launchscreen
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "MapVC") as! MapVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                self.navigationController?.pushViewController(vc, animated: true)
                // Fallback on earlier versions
            }
            
        }
    }
    
    //MARK: Methods
    func loadCache() {
        if UserDefaults.standard.object(forKey: Constants.registeredUsers) != nil {
            Global.userData = (NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: Constants.registeredUsers) as? Data)!) as? UserMapper)!
        } else {
            //Global.userData = UserMapper(fromDictionary: [:])
        }
    }
}
