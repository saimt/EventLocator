//
//  Extensions.swift
//  EventLocator
//
//  Created by Saim on 24/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
extension UIView {
    func showLoader() {
        let blurLoader = BlurLoader(frame: frame)
        self.addSubview(blurLoader)
    }
    
    func removeLoader() {
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension Date {
    
//    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        
//        return dateFormatter.string(from: self)
//    }
    func currentTimeMillis() -> Int64 {
        return Int64((self.timeIntervalSince1970 * 1000).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension String {
    func convertToTimestamp() -> Int64 {
        let yourDate = self

        //initialize the Date Formatter
        let dateFormatter = DateFormatter()
        
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //specify the date Format
        dateFormatter.dateFormat="dd.MM.yyyy, hh.mm aa"

        //get date from string
        let dateString = dateFormatter.date(from: yourDate)

        //get timestamp from Date
        return Int64((dateString!.timeIntervalSince1970 * 1000).rounded())
    }
    
    
    func calculateDistance(eventLocation: String) -> CLLocationDegrees {
        let firstLocationArray = self.components(separatedBy: ",")
        let secondLocationArray = eventLocation.components(separatedBy: ",")
        let firstLatitude = Double(firstLocationArray[0])!
        let firstLongitude = Double(firstLocationArray[1])!
        let secondLatitude = Double(secondLocationArray[0])!
        let secondLongitude = Double(secondLocationArray[1])!
        let locA = CLLocation(latitude: CLLocationDegrees(firstLatitude), longitude: CLLocationDegrees(firstLongitude))
        let locB = CLLocation(latitude: CLLocationDegrees(secondLatitude), longitude: CLLocationDegrees(secondLongitude))
        return (locA.distance(from: locB).rounded())
    }
}

class BlurLoader: UIView {
    
    var blurEffectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.color = UIColor.gray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
    }
}

extension UIColor {
    static let transparent_radius = UIColor(hex: 0x0B83A9, alpha: 0.3)
    static let theme_purple = UIColor(hex: 0x0B83A9)
    // 0x5856D6 indigo
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
           get {
               return self.placeHolderColor
           }
           set {
               self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
           }
       }
}

extension GMSCircle {

    func bounds() -> GMSCoordinateBounds {

        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {

            let sign:Double = positive ? 1 : -1
            let dx  = sign * self.radius  / 6378000 * (180/Double.pi)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * .pi/180)

            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }

        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),
                                   coordinate: locationMinMax(positive: false))
    }

}
