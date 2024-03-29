//
//  TabBarController.swift
//  OpenMoji
//
//  Created by Sam Eckert on 29.03.24.
//  Copyright © 2024 OpenMoji. All rights reserved.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // SwiftUI view controller setup
        let swiftUIView = AboutView() // Your SwiftUI view
        let swiftUIVC = UIHostingController(rootView: swiftUIView)
        swiftUIVC.tabBarItem = UITabBarItem(title: "About", image: UIImage.init(systemName: "info.circle.fill"), tag: 2)

        self.viewControllers?.append(swiftUIVC)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
