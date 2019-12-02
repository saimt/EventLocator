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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
            let vc = self.storyboard?.instantiateViewController(identifier: "MapVC") as! MapVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
