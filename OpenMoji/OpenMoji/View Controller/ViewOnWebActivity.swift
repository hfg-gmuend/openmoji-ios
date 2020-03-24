//
//  ViewOnWebActivity.swift
//  OpenMoji
//
//  Created by Sam Eckert on 24.03.20.
//  Copyright © 2020 OpenMoji. All rights reserved.
//

import UIKit
import SafariServices


class ViewOnWebActivity: UIActivity {
    override var activityTitle: String?{
        return "View Emoji on Web"
    }
    
    override var activityImage: UIImage?{
        return UIImage(named: "")
    }
    
    override var activityType: UIActivity.ActivityType{
        return .init("org.openmoji.iOS-app.open-on-web-activity")
    }
    
    //view controller for the activity
    override var activityViewController: UIViewController?{
        return nil
    }
    
    //here check whether this activity can perfor with given list of items
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    //prepare the data to perform with
    override func prepare(withActivityItems activityItems: [Any]) {
        
    }
}
