//
//  StickersPickerCollectionViewController.swift
//  OpenMoji
//
//  Created by Sam Eckert on 04.04.19.
//  Copyright © 2019 OpenMoji. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class StickersPickerCollectionViewController: UICollectionViewController, UITextFieldDelegate {

    // MARK: - Properties
    private let userDefaults = UserDefaults()
    private let reuseIdentifier = "StickerCell"
    private var itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 20.0,
                                             right: 20.0)
    
    
    var isFiltering = false
    var filterText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "OpenMoji"
        self.view.backgroundColor = .white
        searchButton.tintColor = .actionBlue
        
        if let sourceSansFont = UIFont(name: "SourceSansPro-Bold", size: UIFont.labelFontSize){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: sourceSansFont]
        }
                
        setItemsPerRow()
        setupColorButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        StickersManager.shared.getDataFromJSON{ (successfullyParsed) in
            if successfullyParsed{
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
            }else{
                self.collectionView.isHidden = true
            }
        }
    }
    func setItemsPerRow(){
        if self.view.frame.size.width > 750{
            itemsPerRow = 8
        }
    }
    
    // MARK: - UI
    @IBOutlet var chooseColorButton: UIButton!
    var isChoosingColor = false
    var buttonArray = [UIButton]()
    @IBAction func chooseColorButtonAction(_ sender: Any) {
        showColorPicker()
    }
    func setupColorButton(){
        if let colorFromUserDefaultsAsHex = userDefaults.string(forKey: "globalSkinToneColorHex"){
            if let buttonImage = UIImage(named: mapHexToEmoji(hex: colorFromUserDefaultsAsHex)) {
                chooseColorButton.setImage(buttonImage, for: .normal)
                chooseColorButton.imageView?.contentMode = .scaleAspectFit // or .scaleAspectFill
                
                chooseColorButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
                chooseColorButton.heightAnchor.constraint(equalTo: chooseColorButton.widthAnchor).isActive = true
            }
        }
    }
    func showColorPicker(){
        let colorPicker = UIAlertController(title: "Pick a Skin Tone", message: "Select a skin tone for emojis that support customization", preferredStyle: .actionSheet)
        
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

        colorPicker.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        
        self.present(colorPicker, animated: true, completion: nil)
    }
    @objc func colorSelected(hex: String){
        userDefaults.set(hex , forKey: "globalSkinToneColorHex")
        setupColorButton()

        StickersManager.shared.getDataFromJSON { (successfullyParsed) in
            if successfullyParsed{
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
            }else{
                self.collectionView.isHidden = true
            }
        }
    }
    
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
  
    @objc func openWebsite(){
        guard let url = URL(string: "https://openmoji.org") else {return}
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
        
        searchTextField.becomeFirstResponder()
    }
    
    @objc func cancelSearch(){
        
        setupColorButton()
     
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
    
    func filteredArray() -> [Sticker] {
        guard !filterText.isEmpty else {
            return [Sticker]()
        }
        
        let filtered = StickersManager.shared.filteredStickersArray.filter { sticker in
            // Use optional chaining and nil-coalescing to provide default values for optionals
            let annotationContains = sticker.annotation?.lowercased().contains(filterText.lowercased()) ?? false
            let hexcodeContains = sticker.hexcode?.lowercased().contains(filterText.lowercased()) ?? false
            let emojiContains = sticker.emoji?.contains(filterText.lowercased()) ?? false
            let groupContains = sticker.group?.contains(filterText.lowercased()) ?? false
            let subgroupsContains = sticker.subgroups?.contains(filterText.lowercased()) ?? false
            
            // For optional arrays like `tags`, safely check for containment
            let tagsContain = sticker.tags?.contains(where: { $0.lowercased().contains(filterText.lowercased()) }) ?? false
            let openmojiTagsContain = sticker.openmojiTags?.contains(filterText.lowercased()) ?? false

            // Combine all conditions
            return annotationContains || hexcodeContains || emojiContains || groupContains || subgroupsContains || tagsContain || openmojiTagsContain
        }

        return filtered
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
            return StickersManager.shared.filteredStickersArray.count
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
            if let hexcode = StickersManager.shared.filteredStickersArray[indexPath.row].hexcode{
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
            StickersManager.shared.addRecentSticker(filteredArray()[indexPath.row])

            if let hexcode = filteredArray()[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    lastSharedEmojiName = hexcode
                    showShareSheetWith(stickerImage)
                }
            }
        }else{
            StickersManager.shared.addRecentSticker(StickersManager.shared.filteredStickersArray[indexPath.row])

            if let hexcode = StickersManager.shared.filteredStickersArray[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    lastSharedEmojiName = hexcode
                    showShareSheetWith(stickerImage)
                }
            }
        }
        
    }
    var lastSharedEmojiName = ""
    func showShareSheetWith(_ image: UIImage){
        // Set up activity view controller
        let imageToShare = [image]
        let viewOnWebActivity = ViewOnWebActivity()
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: [viewOnWebActivity])
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = []
        
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            if activityType == UIActivity.ActivityType("org.openmoji.iOS-app.open-on-web-activity"){
                guard let urlFromActivity = URL(string: "https://openmoji.org/library/#emoji=" + self.lastSharedEmojiName) else {return}
                let safariViewController = SFSafariViewController(url: urlFromActivity)
                self.present(safariViewController, animated: true, completion: nil)
            }
        }
        
        
        // Present View controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewSearchHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func mapHexToEmoji(hex:String) -> String{
        switch hex{
        case "FCEA2B":
            return "stickers/270C"
        case "fadcbc":
            return "stickers/270C-1F3FB"
        case "e0bb95":
            return "stickers/270C-1F3FC"
        case "bf8f68":
            return "stickers/270C-1F3FD"
        case "9b643d":
            return "stickers/270C-1F3FE"
        case "594539":
            return "stickers/270C-1F3FF"
        default:
            return ""
        }
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
