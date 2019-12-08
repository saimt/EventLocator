//
//  MapVC.swift
//  EventLocator
//
//  Created by Saim on 19/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit
import SDWebImage
import MaterialShowcase
class MapVC: BaseVC {

    
    //MARK:- Outlets
    @IBOutlet weak var btnEventDetails: UIButton!
    @IBOutlet weak var btnDirections: UIButton!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var vwOverlay: UIView!
    @IBOutlet weak var imgEventPicture: UIImageView!
    @IBOutlet weak var vwDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var vwMap: GMSMapView!
    @IBOutlet weak var btnFilter: UIBarButtonItem!
    @IBOutlet weak var btnCreateEvent: UIBarButtonItem!
    
    //MARK:- Variables
    var marker: GMSMarker!
    let locationManager = CLLocationManager()
    var isDetailViewVisible = false
    var tappedEvent: EventMapper!
    var circle: GMSCircle!
    let sequence = MaterialShowcaseSequence()
    var count = 0
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    var directions = DirectionsResponse(fromDictionary: [:])
    var directionsReceived = false
    var polyLine: GMSPolyline!
    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        getCurrentLocation()
        configureMap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = UserDefaults.standard.value(forKey: Constants.showcaseShown) as? Bool {}
            else {
                UserDefaults.standard.setValue(true, forKey: Constants.showcaseShown)
                addShowcase(title: "Settings", subtitle: "Change distance and other settings", barbutton: btnFilter)
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vwDetail.roundCorners([.topRight, .topLeft], radius: 10)
        
    }
    
    //MARK:- Methods
    func initView() {
        vwDetailHeight.constant = 0
        vwOverlay.isHidden = true
        imgEventPicture.layer.cornerRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        vwOverlay.addGestureRecognizer(tapGesture)
    }
    
    func addShowcase(title: String, subtitle: String, barbutton: UIBarButtonItem) {
        let showcase = MaterialShowcase()
        count += 1
        showcase.delegate = self
        showcase.targetHolderRadius = 22
        showcase.targetHolderColor = UIColor.clear
        showcase.backgroundPromptColor = UIColor.theme_purple
        showcase.setTargetView(barButtonItem: barbutton, tapThrough: true)
        showcase.primaryText = title
        showcase.secondaryText = subtitle
        
        showcase.show(completion: {
        })
    }
    
    @objc func overlayTapped() {
        hideDetailView()
    }
    
    func showDetailView(event: EventMapper) {
        if isDetailViewVisible {
            return
        }
        
        isDetailViewVisible = true
        vwDetailHeight.constant = 200
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.vwOverlay.isHidden = false
            self.imgEventPicture.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgEventPicture.sd_setImage(with: URL(string: event.eventCoverThumbnailUrl), placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground, context: nil, progress: nil, completed: nil)
            self.lblEventName.text = event.eventName
        }
    }
    
    func hideDetailView() {
        if !isDetailViewVisible {
            return
        }
        vwOverlay.isHidden = true
        isDetailViewVisible = false
        vwDetailHeight.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func loadData() {
        ApiManager.getNearbyEvents { (status) in
            if status == "success" {
                self.dropEventMarkers()
                self.scheduleNotifications()
            }
        }
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
    
    func dropEventMarkers() {
        for (index,event) in Global.eventsData.enumerated() {
            let eventLocation = event.eventLocation!
            let latLng = eventLocation.components(separatedBy: ",")
            let position = CLLocationCoordinate2DMake(CLLocationDegrees(Double(latLng[0])!), CLLocationDegrees(Double(latLng[1])!))
            let marker = GMSMarker(position: position)
            marker.title = event.eventName
            marker.isFlat = true
            marker.icon = UIImage(named: "ic_pin")
            marker.accessibilityHint = "\(index)"
            marker.map = vwMap
            
        }
    }
    
    func configureMap() {
        vwMap.isMyLocationEnabled = true
        vwMap.settings.compassButton = true
        vwMap.settings.myLocationButton = true
    }
    
    func drawRadius() {
        
        if circle != nil {
            circle.map = nil
        }
        
        let location = Global.userData.userLocation.components(separatedBy: ",")
        let latitude = Double(location[0])
        let longitude = Double(location[1])
        let circleCenter = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!), CLLocationDegrees(longitude!))
        circle = GMSCircle(position: circleCenter, radius: (CLLocationDistance(Global.userData.userRadius * 1000)))
        
        circle.fillColor = UIColor.transparent_radius
        circle.strokeColor = UIColor.theme_purple
        circle.strokeWidth = 2
        circle.map = vwMap
        let locValue = vwMap.myLocation?.coordinate
//        if locValue != nil {
//            setMap(latitude: locValue!.latitude, longitude: locValue!.longitude, zoomLevel: 12)
//        }
        let update = GMSCameraUpdate.fit(circle.bounds())
        vwMap.animate(with: update)
    }
    
    func setMap(latitude: Double, longitude: Double, zoomLevel: Float) {
        vwMap.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        vwMap.delegate = self
    }
    

    
    func drawRoutes() {
        let routes = directions.routes
        let overviewPolyline = routes?.first?.overviewPolyline
        let routePoints = overviewPolyline?.points
        let path = GMSPath.init(fromEncodedPath: routePoints!)
        
        DispatchQueue.main.async {
            
            let bounds = GMSCoordinateBounds(path: path!)
            self.vwMap.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70.0))
            if self.polyLine?.map != nil {
                self.polyLine?.map = nil
            }
            self.polyLine = GMSPolyline(path: path)
            self.polyLine.strokeColor = UIColor.theme_purple
            self.polyLine.strokeWidth = 8.0
            self.polyLine.map = self.vwMap
            
        }
    }
    
    func scheduleNotifications() {
        for event in Global.eventsData {
            let location = event.eventLocation.components(separatedBy: ",")
            let latitude = Double(location[0])!
            let longitude = Double(location[1])!
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = CLCircularRegion(center: center, radius: 300, identifier: event.eventName)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Event Alert!"
            content.body = "There is an event going on near you. Tap to find out!!"
            content.sound = UNNotificationSound.default
            
            let identifier = event.eventName!
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            notificationCenter.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
    }

    //MARK:- Actions
    @IBAction func btnFilterAction(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(identifier: "FiltersVC") as! FiltersVC
        self.present(vc, animated: true) {

        }
        vc.callback = { (sliderValueChanged, switchValueChanged) -> Void in
            if !sliderValueChanged && !switchValueChanged {
                print("Nothing to update")
                
            }
            else {
                self.vwMap.clear()
                self.loadData()
                self.drawRadius()
            }
        }
    }
    
    @IBAction func btnCreateEventAction(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CreateEventVC") as! CreateEventVC
//        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true) {

        }
    }
    
    @IBAction func btnDirectionsAction(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Select transport mode", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Walk", style: .default, handler: { (action) in
            ApiManager.getDirections(origin: Global.userData.userLocation, destination: self.tappedEvent.eventLocation, mode: TransportMode.WALKING.rawValue) { (response, error) in
                if let data = response as? NSDictionary {
                    self.directions = DirectionsResponse(fromDictionary: data as! [String : Any])
                    self.hideDetailView()
                    self.drawRoutes()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Bicycle", style: .default, handler: { (action) in
            ApiManager.getDirections(origin: Global.userData.userLocation, destination: self.tappedEvent.eventLocation, mode: TransportMode.BICYCLING.rawValue) { (response, error) in
                if let data = response as? NSDictionary {
                    self.directions = DirectionsResponse(fromDictionary: data as! [String : Any])
                    self.hideDetailView()
                    self.drawRoutes()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Drive", style: .default, handler: { (action) in
            ApiManager.getDirections(origin: Global.userData.userLocation, destination: self.tappedEvent.eventLocation, mode: TransportMode.DRIVING.rawValue) { (response, error) in
                if let data = response as? NSDictionary {
                    self.directions = DirectionsResponse(fromDictionary: data as! [String : Any])
                    self.hideDetailView()
                    self.drawRoutes()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            
        }
    }
    
    @IBAction func btnEventDetailsAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PicturesVC") as! PicturesVC
        vc.eventData = tappedEvent
        self.present(vc, animated: true) {
            
        }
    }
}

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("did drag")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Latitude: ",marker.position.latitude)
        print("Longitude: ",marker.position.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let tappedIndex = Int(marker.accessibilityHint!) ?? 0
        tappedEvent = Global.eventsData[tappedIndex]
        showDetailView(event: Global.eventsData[tappedIndex])
        return true
    }
}


extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        manager.stopUpdatingLocation()
        Global.userData.userLocation = "\(locValue.latitude),\(locValue.longitude)"
        ApiManager.updateUserData()
        ApiManager.getGeocodeData(latitude: locValue.latitude, longitude: locValue.longitude) { (response) in
//            _ = GecoderResponse(fromDictionary: response as! [String:Any])
            self.setMap(latitude: locValue.latitude, longitude: locValue.longitude, zoomLevel: 13)
            self.drawRadius()
            
        }
    }
}

extension MapVC: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        if count < 2 {
            addShowcase(title: "Events", subtitle: "Tap to add new events", barbutton: btnCreateEvent)
        }
    }
}
