//
//  LegalViewController.swift
//  OpenMoji
//
//  Created by Sam Eckert on 11.04.19.
//  Copyright © 2019 OpenMoji. All rights reserved.
//

import UIKit
import SafariServices

class LegalViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let sourceSansFont = UIFont(name: "SourceSansPro-Bold", size: UIFont.labelFontSize){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: sourceSansFont]
        }
    }
    
    override func viewDidLayoutSubviews() {
        websiteButton.tintColor = .actionBlue
        
        for button in buttonArray{
            button.removeFromSuperview()
        }
        buttonArray.removeAll()
        addColorButtons()
        
        if let colorFromUserDefaultsAsHex = userDefaults.string(forKey: "globalSkinToneColorHex"){            
            switch colorFromUserDefaultsAsHex{
            case "FCEA2B":
                colorSelected(sender: buttonArray[0])
            case "fadcbc":
                colorSelected(sender: buttonArray[1])
            case "e0bb95":
                colorSelected(sender: buttonArray[2])
            case "bf8f68":
                colorSelected(sender: buttonArray[3])
            case "9b643d":
                colorSelected(sender: buttonArray[4])
            case "594539":
                colorSelected(sender: buttonArray[5])
            default:
                break
            }
            
        }
    }
    
    // MARK: - UI
    @IBOutlet var websiteButton: UIButton!
    @IBAction func websiteButtonAction(_ sender: Any) {
        guard let url = URL(string: "http://openmoji.org") else {return}
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    @IBOutlet var buttonView: UIView!
    var buttonArray = [UIButton]()
    let availableColors = ["FCEA2B", "fadcbc", "e0bb95", "bf8f68", "9b643d", "594539"]
    func addColorButtons(){
        
        for index in 0...availableColors.count-1{
            
            //let baseX = 20 //self.view.bounds.width/2-(CGFloat(availableColors.count)*40)/2
            
            let buttonFrame = CGRect(x: CGFloat(index * 40), y: buttonView.bounds.height/2, width: 30, height: 30)
            
            let colorButton = UIButton(frame: buttonFrame)
            colorButton.layer.cornerRadius = colorButton.frame.size.height/2
            colorButton.backgroundColor = UIColor(hex: availableColors[index]).withAlphaComponent(1.0)
            colorButton.addTarget(self, action: #selector(colorSelected(sender:)), for: .touchUpInside)
            colorButton.tag = index
            
            /*if availableColors[index] == .black{
                colorButton.layer.borderWidth = 5
                colorButton.layer.borderColor = UIColor.gray.cgColor
            }*/
            
            buttonArray.append(colorButton)
            self.buttonView.addSubview(colorButton)
        }
    }
    
    @objc func colorSelected(sender: UIButton){
        
        for button in buttonArray{
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
        }
        
        userDefaults.set(availableColors[sender.tag] , forKey: "globalSkinToneColorHex")
        
        sender.layer.borderWidth = 5
        sender.layer.borderColor = UIColor.gray.cgColor
    }
    
    // MARK: - Navigation

    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
