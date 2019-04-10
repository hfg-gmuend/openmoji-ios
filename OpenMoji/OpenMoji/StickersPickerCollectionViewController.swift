//
//  StickersPickerCollectionViewController.swift
//  OpenMoji
//
//  Created by Sam Eckert on 04.04.19.
//  Copyright © 2019 OpenMoji. All rights reserved.
//

import UIKit
import Unbox

class StickersPickerCollectionViewController: UICollectionViewController, UITextFieldDelegate {

    // MARK: - Properties
    private let reuseIdentifier = "StickerCell"
    private let itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    
    var stickersArray = [Sticker]()
    var isFiltering = false
    var filterText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "OpenMoji"
        
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
    
    //MARK: - SEARCH
    var searchTextField = UITextField()
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBAction func searchButtonAction(_ sender: Any) {
        searchTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        searchTextField.placeholder = "Search"
        searchTextField.clearButtonMode = .always
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelSearch)), animated: true)
        self.navigationItem.titleView = self.searchTextField
        
        
        searchTextField.becomeFirstResponder()
    }
    
    @objc func cancelSearch(){
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
        
        return true
    }
    
    func updateSearchResults(_ searchText: String, completion: () -> Void){
        isFiltering = true
        filterText = searchText
        completion()
    }
    
    func filteredArray() -> [Sticker]{
        if filterText != ""{
            return stickersArray.filter{ $0.annotation!.contains(filterText) || $0.hexcode!.contains(filterText) || $0.emoji!.contains(filterText) || $0.group!.contains(filterText) || $0.subgroups!.contains(filterText) || $0.tags!.contains(filterText) }
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
                    cell.imageView.image = nil
                    cell.imageView.isHidden = true
                    cell.backgroundColor = UIColor.darkGray
                }
            }else{
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
                    cell.imageView.image = nil
                    cell.imageView.isHidden = true
                    cell.backgroundColor = UIColor.darkGray
                }
            }else{
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
                //print(imageName)
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    UIPasteboard.general.image = stickerImage
                    print("Copied image")
                    showCopiedView(imageName: imageName)
                }
            }
        }else{
            if let hexcode = stickersArray[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                //print(imageName)
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    UIPasteboard.general.image = stickerImage
                    print("Copied image")
                    showCopiedView(imageName: imageName)
                }
            }
        }
        
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
}
