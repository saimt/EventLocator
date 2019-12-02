//
//  CreateEventVC.swift
//  EventLocator
//
//  Created by Saim on 19/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import UIKit
import GooglePlaces
class CreateEventVC: BaseVC {

    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnCreate: UIBarButtonItem!
    @IBOutlet weak var btnSelectCoverPhoto: UIButton!
    @IBOutlet weak var txtEventName: UITextField!
    @IBOutlet weak var txtEventLocation: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    
    var eventData = EventMapper(fromDictionary: [:])
    var coverPhoto: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        let textfields = [txtEventName,txtEventLocation,txtStartTime,txtEndTime]
        for textfield in textfields {
            textfield!.delegate = self
        }
        txtStartTime.tag = 2
        txtEndTime.tag = 3
    }

    @IBAction func btnCreateAction(_ sender: UIBarButtonItem) {
        if coverPhoto == nil {
            self.showToast("Please select event cover photo")
        }
        else if eventData.eventName == nil {
            self.showToast("Please enter event name")
        }
        else if eventData.eventLocation == nil {
            self.showToast("Please select event location")
        }
        else if eventData.eventStart == nil {
            self.showToast("Please enter event start time")
        }
        else if eventData.eventEnd == nil {
            self.showToast("Please enter event end time")
        }
        else {
            self.showLoader()
            ApiManager.createEvent(event: eventData, coverPhoto: coverPhoto) { (status, error) in
                self.hideLoader()
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.showToast(error!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func btnSelectCoverPhotoAction(_ sender: UIButton) {
        ImagePickerManager.init().pickImage(self) { (image) in
            self.imgCover.image = image
            self.coverPhoto = image
        }
    }
    
    @IBAction func textChangeAction(_ sender: UITextField) {
        eventData.eventName = sender.text
    }
    
}

extension CreateEventVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            return true
        }
        else if textField.tag == 1 {
            self.view.endEditing(true)
            let vc = self.storyboard?.instantiateViewController(identifier: "DraggableMapVC") as! DraggableMapVC
            self.present(vc, animated: true) {
                
            }
            vc.callback = { (address,coordinates) -> Void in
                self.txtEventLocation.text = address
                self.eventData.eventLocation = coordinates
            }
            return false
        }
        else if textField.tag == 2 {
            self.view.endEditing(true)
            let alert = UIAlertController(style: .actionSheet, title: "Select start time")
            alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: Date(), maximumDate: Date().dateByAddingYears(5)) { date in
                // action with selected date
                textField.text = date.dateTimeString(ofStyle: .medium)
                self.eventData.eventStart = Double(date.dateTimeString().convertToTimestamp())
            }
            alert.addAction(title: "OK", style: .cancel)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        else {
            self.view.endEditing(true)
            let alert = UIAlertController(style: .actionSheet, title: "Select end time")
            alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: Date(), maximumDate: Date().dateByAddingYears(5)) { date in
                // action with selected date
                textField.text = date.dateTimeString(ofStyle: .medium)
                self.eventData.eventEnd = Double(date.dateTimeString().convertToTimestamp())
            }
            alert.addAction(title: "OK", style: .cancel)
            self.present(alert, animated: true, completion: nil)
            return false

        }
    }
    
    
}
