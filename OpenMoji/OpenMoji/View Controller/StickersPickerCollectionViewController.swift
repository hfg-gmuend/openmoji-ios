//
//  StickersPickerCollectionViewController.swift
//  OpenMoji
//
//  Created by Sam Eckert on 04.04.19.
//  Copyright © 2019 OpenMoji. All rights reserved.
//

import Foundation
import UIKit
import Unbox
import SwiftyStringScore
import SafariServices

class StickersPickerCollectionViewController: UICollectionViewController, UITextFieldDelegate {

    // MARK: - Properties
    private let userDefaults = UserDefaults()
    private let reuseIdentifier = "StickerCell"
    private let itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 20.0,
                                             right: 20.0)
    
    
    var stickersArray = [Sticker]()
    var isFiltering = false
    var filterText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "OpenMoji"
        searchButton.tintColor = .actionBlue
        
        if let sourceSansFont = UIFont(name: "SourceSansPro-Bold", size: UIFont.labelFontSize){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: sourceSansFont]
            
        }
        
        setupToolbar()
        setupColorButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDataFromJSON { (successfullyParsed) in
            if successfullyParsed{
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
            }else{
                self.collectionView.isHidden = true
            }
        }
    }
    
    // MARK: - Data
    func getDataFromJSON(completion: (Bool) -> Void){
        if let jsonFilePath = Bundle.main.url(forResource: "openmoji", withExtension: "json"){
            do{
                let jsonFileData = try Data(contentsOf: jsonFilePath)
                let stickers: [Sticker] = try unbox(data: jsonFileData)
                stickersArray = stickers
                
                if let colorFromUserDefaultsAsHex = userDefaults.string(forKey: "globalSkinToneColorHex"){
                    var isNotStandard = false
                    var skinToneModifiers = [
                        "1F3FB",
                        "1F3FC",
                        "1F3FD",
                        "1F3FE",
                        "1F3FF"
                    ]
                    
                    switch colorFromUserDefaultsAsHex{
                    case "FCEA2B":
                        isNotStandard = false
                        //skinToneModifiers.remove(at: 0)
                    case "fadcbc":
                        isNotStandard = true
                        skinToneModifiers.remove(at: 0)
                    case "e0bb95":
                        isNotStandard = true
                        skinToneModifiers.remove(at: 1)
                    case "bf8f68":
                        isNotStandard = true
                        skinToneModifiers.remove(at: 2)
                    case "9b643d":
                        isNotStandard = true
                        skinToneModifiers.remove(at: 3)
                    case "594539":
                        isNotStandard = true
                        skinToneModifiers.remove(at: 4)
                    default:
                        break
                    }
                    
                    if isNotStandard == true{
                        // Removes all yellow skin color emojis
                        stickersArray.removeAll(where: {
                            $0.hexcode == $0.skintoneBaseHexcode
                        })
                        
                        // Gets rid of all other unwanted skin colors
                        for skinTone in skinToneModifiers{
                            stickersArray.removeAll(where: {
                                $0.hexcode?.contains("-"+skinTone) == true
                            })
                        }
                    }else{
                        // Gets rid of all other unwanted skin colors
                        for skinTone in skinToneModifiers{
                            stickersArray.removeAll(where: {
                                $0.hexcode?.contains("-"+skinTone) == true
                            })
                        }
                    }
                    
                    stickersArray.removeAll(where: {
                        $0.skintoneCombination?.contains("multiple") == true
                    })
                }
                
                print("Successfully parsed Stickers")
                completion(true)
            }catch {
                print("Error \(error)")
                completion(false)
            }
        }else{
            print("openmoji.json is inaccesible")
            completion(false)
        }
    }
    
    // MARK: - UI
    let availableColors = ["FCEA2B", "fadcbc", "e0bb95", "bf8f68", "9b643d", "594539"]
    @IBOutlet var chooseColorButton: UIButton!
    var isChoosingColor = false
    var buttonArray = [UIButton]()
    @IBAction func chooseColorButtonAction(_ sender: Any) {
        showColorPicker()
    }
    func setupColorButton(){
        if let colorFromUserDefaultsAsHex = userDefaults.string(forKey: "globalSkinToneColorHex"){
            chooseColorButton.backgroundColor = UIColor.init(hex: colorFromUserDefaultsAsHex)
            chooseColorButton.layer.cornerRadius = chooseColorButton.frame.size.height/2
        }
    }
    func showColorPicker(){
        let colorPicker = UIAlertController(title: "Choose Skin Tone", message: "Choose which skin tone the emojis shall have", preferredStyle: .actionSheet)
        
        let yellowAlertAction = UIAlertAction(title: "✌️", style: .default) { (action) in
            self.colorSelected(hex: "FCEA2B")
        }
        
        let skin1AlertAction = UIAlertAction(title: "✌🏻", style: .default) { (action) in
            self.colorSelected(hex: "fadcbc")
        }
        
        let skin2AlertAction = UIAlertAction(title: "✌🏼", style: .default) { (action) in
            self.colorSelected(hex: "e0bb95")
        }
        
        let skin3AlertAction = UIAlertAction(title: "✌🏽", style: .default) { (action) in
            self.colorSelected(hex: "bf8f68")
        }
        
        let skin4AlertAction = UIAlertAction(title: "✌🏾", style: .default) { (action) in
            self.colorSelected(hex: "9b643d")
        }
        
        let skin5AlertAction = UIAlertAction(title: "✌🏿", style: .default) { (action) in
            self.colorSelected(hex: "594539")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        colorPicker.addAction(yellowAlertAction)
        colorPicker.addAction(skin1AlertAction)
        colorPicker.addAction(skin2AlertAction)
        colorPicker.addAction(skin3AlertAction)
        colorPicker.addAction(skin4AlertAction)
        colorPicker.addAction(skin5AlertAction)
        colorPicker.addAction(cancelAction)

        self.present(colorPicker, animated: true, completion: nil)
    }
    @objc func colorSelected(hex: String){
        chooseColorButton.backgroundColor = UIColor.init(hex: hex)
        userDefaults.set(hex , forKey: "globalSkinToneColorHex")
        
        getDataFromJSON { (successfullyParsed) in
            if successfullyParsed{
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
            }else{
                self.collectionView.isHidden = true
            }
        }
    }
    
    @IBOutlet var aboutBarButtonItem: UIBarButtonItem!
    func showCopiedView(imageName: String){
        let copiedViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let copiedView = UIView(frame: copiedViewFrame)
        copiedView.center = self.view.center
        copiedView.backgroundColor = .clear
        copiedView.alpha = 0
        copiedView.layer.cornerRadius = 20
        copiedView.clipsToBounds = true
        
        let copiedVisualEffectView = UIVisualEffectView(frame: copiedViewFrame)
        copiedVisualEffectView.effect = UIBlurEffect(style: .prominent)
        copiedVisualEffectView.layer.cornerRadius = 20
        copiedVisualEffectView.clipsToBounds = true
        copiedView.addSubview(copiedVisualEffectView)
        
        
        let copiedImageViewFrame = CGRect(x: 0, y: 0, width: 150, height: 150)
        let copiedImageView = UIImageView(frame: copiedImageViewFrame)
        copiedImageView.image = UIImage(named: imageName)
        copiedImageView.center = CGPoint(x: copiedView.bounds.width/2, y: copiedView.bounds.height/2-25)
        
        copiedView.addSubview(copiedImageView)
        
        
        
        let copiedLabelFrame = CGRect(x: 0, y: 0, width: 200, height: 20)
        let copiedLabel = UILabel(frame: copiedLabelFrame)
        copiedLabel.text = "Copied to clipboard!"
        copiedLabel.textAlignment = .center
        copiedLabel.textColor = .darkGray
        copiedLabel.center = CGPoint(x: copiedView.bounds.width/2, y: copiedView.bounds.height-30)
        
        copiedView.addSubview(copiedLabel)
        
        self.view.addSubview(copiedView)
        
        UIView.animate(withDuration: 0.5) {
            copiedView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5, animations: {
                copiedView.alpha = 0
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                copiedView.removeFromSuperview()
            }
        }
    }
    func setupToolbar(){
        let websiteBarButtonItem = UIBarButtonItem(title: "OpenMoji.org", style: .plain, target: self, action: #selector(openWebsite))
        websiteBarButtonItem.tintColor = .actionBlue
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        
        let licenseLabelContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        let licenseLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: 120, height: 30))
        licenseLabel.text = "License: CC BY-SA 4.0"
        licenseLabel.textAlignment = .right
        licenseLabel.font = UIFont(name: "SourceSansPro-Regular", size: 12)
        
        licenseLabelContainerView.addSubview(licenseLabel)
        
        let licenseText = UIBarButtonItem(customView: licenseLabelContainerView)
        
      
        self.toolbarItems = [websiteBarButtonItem, flexibleSpacer, licenseText]
    }
    @objc func openWebsite(){
        guard let url = URL(string: "http://openmoji.org") else {return}
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    //MARK: - SEARCH
    var searchTextField = UITextField()
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBAction func searchButtonAction(_ sender: Any) {
        searchTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        searchTextField.placeholder = "Search"
        searchTextField.clearButtonMode = .always
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.autocorrectionType = .no
        searchTextField.tintColor = .actionBlue
        
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelSearch))
        cancelButtonItem.tintColor = .actionBlue
        
        self.navigationItem.setRightBarButton(cancelButtonItem, animated: true)
        self.navigationItem.titleView = self.searchTextField
        self.navigationItem.setLeftBarButton(nil, animated: true)
        
        searchTextField.becomeFirstResponder()
    }
    
    @objc func cancelSearch(){
        
        let button = UIBarButtonItem(customView: chooseColorButton)
        
        self.navigationItem.setLeftBarButton(button, animated: true)
        self.navigationItem.setRightBarButton(self.searchButton, animated: true)
        self.searchTextField.text = nil
        self.navigationItem.titleView = nil

        self.title = "OpenMoji"
       
        searchTextField.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        isFiltering = false
        self.collectionView?.reloadData()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == nil || textField.text?.isEmpty ?? true || textField.text == "" || textField.text == " "{
            print("isFiltering will be set to false")
            isFiltering = false
            self.collectionView?.reloadData()
        }else{
            updateSearchResults(textField.text!) {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        if filterText.isEmpty || filterText == "" || filterText == " "{
            cancelSearch()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if filterText.isEmpty || filterText == "" || filterText == " "{
            cancelSearch()
        }
        return true
    }
    
    func updateSearchResults(_ searchText: String, completion: () -> Void){
        isFiltering = true
        filterText = searchText
        completion()
    }
    
    func filteredArray() -> [Sticker]{
        if filterText != ""{
            return stickersArray.filter({
                $0.annotation!.contains(filterText.lowercased()) ||
                $0.hexcode!.contains(filterText) ||
                $0.hexcode!.contains(filterText.lowercased()) ||
                $0.emoji!.contains(filterText.lowercased()) ||
                $0.group!.contains(filterText.lowercased()) ||
                $0.subgroups!.contains(filterText.lowercased()) ||
                $0.tags!.contains(filterText.lowercased()) ||
                $0.openmojiTags!.contains(filterText.lowercased())
            })
        }else{
            return [Sticker]()
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if isFiltering{
            //print("filteredArray is \(filteredArray())")
            print(filteredArray().count)
            return filteredArray().count
        }else{
            return stickersArray.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StickersPickerCollectionViewCell
    
        if isFiltering{
            if let hexcode = filteredArray()[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                //print(imageName)
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    cell.imageView.image = stickerImage
                    cell.imageView.isHidden = false
                    cell.backgroundColor = UIColor.clear
                }else{
                    print("🥶 Error loading image named: \(imageName)")
                    cell.imageView.image = nil
                    cell.imageView.isHidden = true
                    cell.backgroundColor = UIColor.darkGray
                }
            }else{
                print("🥶 Error loading image with hexcode: \(String(describing: filteredArray()[indexPath.row].hexcode))")
                cell.imageView.image = nil
                cell.imageView.isHidden = true
                cell.backgroundColor = UIColor.darkGray
            }
        }else{
            if let hexcode = stickersArray[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                //print(imageName)
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    cell.imageView.image = stickerImage
                    cell.imageView.isHidden = false
                    cell.backgroundColor = UIColor.clear
                }else{
                    print("🥶 Error loading image named: \(imageName)")
                    cell.imageView.image = nil
                    cell.imageView.isHidden = true
                    cell.backgroundColor = UIColor.darkGray
                }
            }else{
                print("🥶 Error loading image with hexcode: \(String(describing: filteredArray()[indexPath.row].hexcode))")

                cell.imageView.image = nil
                cell.imageView.isHidden = true
                cell.backgroundColor = UIColor.darkGray
            }
        }
        
        cell.layer.cornerRadius = 10
        
        return cell

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            collectionView.cellForItem(at: indexPath)!.backgroundColor = UIColor.lightGray
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.5) {
                collectionView.cellForItem(at: indexPath)!.backgroundColor = UIColor.clear
            }
        }
        
        if isFiltering{
            if let hexcode = filteredArray()[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    showShareSheetWith(stickerImage)
                }
            }
        }else{
            if let hexcode = stickersArray[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    showShareSheetWith(stickerImage)
                }
            }
        }
        
    }
    func showShareSheetWith(_ image: UIImage){
        // Set up activity view controller
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = []
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewSearchHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
}

extension StickersPickerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
        self.view.setNeedsDisplay()
    }
}
