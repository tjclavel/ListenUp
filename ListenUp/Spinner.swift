//
//  Spinner.swift
//  ListenUp
//
//  Created by Thomas Clavelli on 9/18/17.
//  Copyright © 2017 Thomas Clavelli. All rights reserved.
//

import UIKit

class Spinner: UIView {
    
    var perc: CGFloat?
    
    override func draw(_ rect: CGRect) {
        let greyPath = UIBezierPath(arcCenter: CGPoint(x: rect.maxX / 2, y: rect.maxY / 2), radius: 7, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        greyPath.lineWidth = 3
        UIColor(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1).set()
        greyPath.stroke()
        if perc == nil || perc == 0{
            perc = 0.01
        }
        let angleOffset = CGFloat(Double.pi / -2)
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.maxX / 2, y: rect.maxY / 2), radius: 7, startAngle: angleOffset, endAngle: CGFloat(Double.pi * 2) * perc! + angleOffset, clockwise: true)
        path.lineWidth = 3
        if perc! <= CGFloat(0.25) {
            UIColor.red.set()
        } else {
            UIColor.green.set()
        }
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }

}
