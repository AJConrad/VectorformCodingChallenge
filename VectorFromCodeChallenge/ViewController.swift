//
//  ViewController.swift
//  VectorFromCodeChallenge
//
//  Created by Andrew Conrad on 7/17/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

// turn 90 degrees = 1/2 pi = 1.580796
// turn 45 degrees = 1/4 pi = 0.785398
// turn 135 degrees = 3/4 pi = 2.356194
// turn 225 degrees = 5/4 pi = 3.926990
// turn 315 degrees = 7/4 pi = 5.497787
// turn 360 degrees = 8/4 pi = 6.283185
// turn 405 degrees = 9/4 pi = 7.068583
//green = color 1
//blue = color 2
//purple = color 3
//red = color 4

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet   weak    var     colorPickView: UIView!
    
    var session: WCSession?
    var lastRotation:CGFloat = 0.0
    var currentColor = 1
    var angleSize:CGFloat = CGFloat((2*M_PI)/4) //hard coded for 4 colors here
    
    
    //MARK: - Rotation Methods
    
    @IBAction func wheelSpinner (gesture: UIRotationGestureRecognizer) {
        //Live rotationg
        let rotation:CGFloat = 0.0 - (lastRotation - gesture.rotation)
        let currentTransform:CGAffineTransform = colorPickView.transform
        let newTransform:CGAffineTransform = CGAffineTransformRotate(currentTransform, rotation)
        colorPickView.transform = newTransform
        lastRotation = gesture.rotation
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            //if it spun counter-clockwise
            if lastRotation < 0 {
                lastRotation = lastRotation * -1.0 //make positive to do math to it
                determineColorChosenCounterClockwise()
                let finalAngleRotations:CGFloat = CGFloat(currentColor - 1) //number of sections clockwise
                                                                            //that the wheel turns
                //set to color 1 upright
                colorPickView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0)
                
                //spin to chosen color
                colorPickView.transform = CGAffineTransformMakeRotation(angleSize*finalAngleRotations)
                
            } else {
                determineColorChosenClockwise()
                let finalAngleRotations:CGFloat = CGFloat(currentColor - 1)
                colorPickView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0)
                colorPickView.transform = CGAffineTransformMakeRotation(angleSize*finalAngleRotations)
            }
            
            //Send message over to the watch about what color is chosen
            if let validSession = session {
                let colorChangedContext = ["color": currentColor]
                do {
                    try validSession.updateApplicationContext(colorChangedContext)
                } catch {
                    print ("Error in transfering data")
                }
            }
            //reset the rotation holding value
            lastRotation = 0.0
        }
    }
    
    func determineColorChosenClockwise() {
        //if it moved more than one full circle and a quarter turn, subtract 1 full circle
        while lastRotation > 7.068583 {
            lastRotation = lastRotation - 6.283185
        }
        if (0 < lastRotation && lastRotation < 0.785398) {
            //current color stays the same since it didnt move more than 1/4 a turn
        } else if (0.785398 < lastRotation && lastRotation < 2.356194) {
            currentColor += 1
            //current color becomes the one to its clockwise since between 1/4 and 3/4 a turn, etc below
        } else if (2.356194 < lastRotation && lastRotation < 3.926990) {
            currentColor += 2
        } else if (3.926990 < lastRotation && lastRotation < 5.497787) {
            currentColor += 3
        } else if (5.497787 < lastRotation && lastRotation < 7.068583) {
            currentColor += 4
        } else {
            print("Error in determine color method")
        }
        //if the color goes above the number listed, it goes back to the starting one
        while currentColor > 4 {
            currentColor = currentColor - 4
        }
    }
    
    //The difference between these methods is the -=, as well as flipping the rule for going over/under 4
    func determineColorChosenCounterClockwise() {
        while lastRotation > 7.068583 {
            lastRotation = lastRotation - 6.283185
        }
        if (0 < lastRotation && lastRotation < 0.785398) {
            //current color stays the same
        } else if (0.785398 < lastRotation && lastRotation < 2.356194) {
            currentColor -= 1
            //current color becomes the one to its counterclockwise
        } else if (2.356194 < lastRotation && lastRotation < 3.926990) {
            currentColor -= 2
        } else if (3.926990 < lastRotation && lastRotation < 5.497787) {
            currentColor -= 3
        } else if (5.497787 < lastRotation && lastRotation < 7.068583) {
            currentColor -= 4
        } else {
            print("Error in determine color method")
        }
        while currentColor < 1 {
            currentColor = currentColor + 4
        }
    }
    
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session?.delegate = self
            session?.activateSession()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}