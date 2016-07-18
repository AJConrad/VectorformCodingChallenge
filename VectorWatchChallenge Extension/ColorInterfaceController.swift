//
//  ColorInterfaceController.swift
//  VectorFromCodeChallenge
//
//  Created by Andrew Conrad on 7/17/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ColorInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    let session = WCSession.defaultSession()
    @IBOutlet var colorImage: WKInterfaceImage!
    
    func processApplicationContext() {
        if let iPhoneContext = session.receivedApplicationContext as? [String : Int] {
           
            // Initialize graphics context
            let size = CGSizeMake(100, 100)
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()
            UIGraphicsPushContext(context!)
            
            //Color Check
            if iPhoneContext ["color"] == 1 {
                UIColor.greenColor().setStroke()
                UIColor.greenColor().setFill()
            } else if iPhoneContext ["color"] == 2 {
                UIColor.blueColor().setStroke()
                UIColor.blueColor().setFill()
            } else if iPhoneContext ["color"] == 3 {
                UIColor.purpleColor().setStroke()
                UIColor.purpleColor().setFill()
            } else if iPhoneContext ["color"] == 4 {
                UIColor.redColor().setStroke()
                UIColor.redColor().setFill()
            }
            
            // Draw the circle
            let rect = CGRectMake(2, 2, 96, 96)
            let path = UIBezierPath(ovalInRect: rect)
            path.lineWidth = 4.0
            path.fill()
            path.stroke()
            
            // Convert to UIImage and apply to UIImage
            let cgimage = CGBitmapContextCreateImage(context);
            let uiimage = UIImage(CGImage: cgimage!)
            
            // End the graphics context and set
            UIGraphicsPopContext()
            UIGraphicsEndImageContext()
            colorImage.setImage(uiimage)
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.processApplicationContext()
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        session.delegate = self
        session.activateSession()
    }
}
