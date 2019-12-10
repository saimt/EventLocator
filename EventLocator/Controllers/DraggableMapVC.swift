//
//  DraggableMapVC.swift
//  EventLocator
//
//  Created by Saim on 25/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MaterialShowcase
class DraggableMapVC: BaseVC {

    //MARK: Outlets
    @IBOutlet var vwMap: GMSMapView!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var txtLocationName: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    //MARK: Variables
    var callback: ((_ locationName: String,_ cordinates: String) -> Void)?
    var marker: GMSMarker!
    let locationManager = CLLocationManager()
    var selectedCoordinates = ""
    
    //MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configureMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = UserDefaults.standard.value(forKey: Constants.mapsShowcaseShown) as? Bool {}
        else {
            UserDefaults.standard.setValue(true, forKey: Constants.mapsShowcaseShown)
            addShowcase(title: "Select Location", subtitle: "Long tap on marker to drag the marker")
        }
        
    }
    //MARK: Methods
    func initView() {
        txtLocationName.setLeftPaddingPoints(10)
    }
    
    func configureMap() {
//        vwMap.isMyLocationEnabled = true
        vwMap.settings.compassButton = true
        vwMap.settings.myLocationButton = true
    }
    
    func addShowcase(title: String, subtitle: String) {
        let showcase = MaterialShowcase()
        showcase.targetHolderRadius = 0
        showcase.targetHolderColor = UIColor.clear
        showcase.backgroundPromptColor = UIColor.theme_purple
        showcase.setTargetView(view: vwMap)
        showcase.primaryText = title
        showcase.secondaryText = subtitle
        showcase.backgroundViewType = .full
        showcase.show(completion: {
        })
    }
    
    func setMap(latitude: Double, longitude: Double, locationName: String) {
        vwMap.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 13.0)
        marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        marker.title = locationName
        marker.isDraggable = true
        marker.map = vwMap
        marker.icon = UIImage(named: "ic_marker")
        vwMap.delegate = self
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: Actions
    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.callback?("","")
        }
    }
    
    @IBAction func btnDoneAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.callback?(self.txtLocationName.text ?? "", self.selectedCoordinates)
        }
        
    }
}

extension DraggableMapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        ApiManager.getGeocodeData(latitude: marker.position.latitude, longitude: marker.position.longitude) { (response) in
            let geocodeData = GecoderResponse(fromDictionary: response as! [String:Any])
            self.txtLocationName.text = geocodeData.results.first?.formattedAddress
            
            self.selectedCoordinates = "\(marker.position.latitude),\(marker.position.longitude)"
            self.marker.title = geocodeData.results.first?.formattedAddress
            
        }
    }
}

extension DraggableMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        manager.stopUpdatingLocation()
        ApiManager.getGeocodeData(latitude: locValue.latitude, longitude: locValue.longitude) { (response) in
            let geocodeData = GecoderResponse(fromDictionary: response as! [String:Any])
            self.txtLocationName.text = geocodeData.results.first?.formattedAddress
            self.selectedCoordinates = "\(locValue.latitude),\(locValue.longitude)"
            self.setMap(latitude: locValue.latitude, longitude: locValue.longitude, locationName: geocodeData.results.first?.formattedAddress ?? "")
            
        }
    }
}
