//
//  BaseVC.swift
//  EventLocator
//
//  Created by Saim on 24/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
class BaseVC: UIViewController {

    //MARK: Variables
    var isIndicatorShown = false
    var activityIndicator: NVActivityIndicatorView!
    
    //MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Methods
    func showToast(_ message: String,_ type: String = "default") {
        // create a new style
        var style = ToastStyle()

        // this is just one of many style options
        if type == "error" {
            style.backgroundColor = .red
        }
        self.view.makeToast(message, duration: 2.0, position: .bottom, style: style)
    }
    
    func showLoader(message: String = "") {
        if isIndicatorShown {
            return
        }
        
        let activityData = ActivityData(size: nil, message: message, messageFont: nil, messageSpacing: nil, type: .ballClipRotatePulse, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        isIndicatorShown = true
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func hideLoader() {
        isIndicatorShown = false
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    
}
