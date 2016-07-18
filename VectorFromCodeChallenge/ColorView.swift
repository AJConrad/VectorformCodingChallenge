//
//  ColorView.swift
//  VectorFromCodeChallenge
//
//  Created by Andrew Conrad on 7/17/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit

class colorView: UIView {
    
    //Inital drawing is purple down to start, green top, blue left, red right
    
    override func drawRect(rect: CGRect) {
        func drawColorWheel(colors:[(value:CGFloat, color:UIColor)], at center:CGPoint, radius:CGFloat) {
            let numberOfColors:CGFloat = colors.reduce(0, combine: {$0 + $1.value})
            var angle:CGFloat = -CGFloat(M_PI)/4
            
            //colors is an array right now just in code, but could be made to be read from a JSON or such
            for (value,color) in colors {
                let path = UIBezierPath()
                let colorAngle = CGFloat(M_PI)*2*value/numberOfColors
                color.setFill()
                
                path.moveToPoint(center)
                path.addArcWithCenter(center, radius: radius, startAngle: angle, endAngle: angle - colorAngle, clockwise: false)
                path.moveToPoint(center)
                path.closePath()
                
                path.fill()
                
                angle -= colorAngle
            }
        }
        
        //The array of the available colors. Tuples, first number is a value since this was related to
        //drawing a pie chart, set those numbers all equal for same sized pieces. 
        //the second thing is the UIColor that is gonna get drawn.
        let colors:[(value:CGFloat, color:UIColor)] =
            [ (1, UIColor.greenColor()),
              (1, UIColor.blueColor()),
              (1, UIColor.purpleColor()),
              (1, UIColor.redColor())
        ]
        
        let viewSize = CGSize(width: 300, height: 300)
        let colorWheelView:UIView = UIView(frame: CGRect(origin: CGPointZero, size: viewSize))
        colorWheelView.backgroundColor = UIColor.cyanColor()
        
        //these numbers are based off hard coded bounds for screen size, could change to be dynamic
        drawColorWheel(colors, at: CGPointMake(150, 150), radius:100)
    }
}
