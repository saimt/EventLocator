//
//  Helper.swift
//  EventLocator
//
//  Created by Saim on 25/11/2019.
//  Copyright © 2019 Saim. All rights reserved.
//

import Foundation
import UIKit
class TriangleView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        context.setFillColor(UIColor.groupTableViewBackground.cgColor)
            //.setFillColor(red: 201.0, green: 201, blue: 201, alpha: 0)
        context.fillPath()
    }
}

enum TransportMode: String {
    case WALKING = "walking"
    case DRIVING = "driving"
    case BICYCLING = "bicycling"
    case TRANSIT = "transit"
}
