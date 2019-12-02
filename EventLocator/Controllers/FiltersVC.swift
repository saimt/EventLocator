//
//  FiltersVC.swift
//  EventLocator
//
//  Created by Saim on 24/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import UIKit

class FiltersVC: BaseVC {

    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var sliderDistance: UISlider!
    @IBOutlet weak var switchEndedEvents: UISwitch!
    
    
    var callback: ((_ distanceChanged: Bool, _ showEventsChanged: Bool) -> Void)?
    var sliderValueChanged = false
    var switchValueChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliderData()
        switchEndedEvents.isOn = Global.userData.showEndedEvents
    }
    
    func setupSliderData() {
        var radius = 0.2
        if Global.userData.userRadius != nil {
            radius = Double(Global.userData.userRadius * 0.1)
        }
        sliderDistance.setValue(Float(radius), animated: true)
        lblDistance.text = "\(Int(radius * 10)) km"
        
        ApiManager.updateUserData()
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        Global.userData.userRadius = Float(Int(sender.value * 10))
        lblDistance.text = "\(Int(sender.value * 10)) km"
        ApiManager.updateUserData()
        sliderValueChanged = true
        
    }
    
    
    @IBAction func btnDismissAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.callback?(self.sliderValueChanged, self.switchValueChanged)
        }
    }

    @IBAction func switchValueChanges(_ sender: UISwitch) {
        Global.userData.showEndedEvents = sender.isOn
        ApiManager.updateUserData()
        switchValueChanged = true
    }
}
