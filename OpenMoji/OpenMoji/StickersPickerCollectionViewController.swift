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
    var searchTextField = UITextField()
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBAction func searchButtonAction(_ sender: Any) {
        searchTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        searchTextField.backgroundColor = .white
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
    
    //MARK: - SEARCH
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
        if filterText == nil || filterText.isEmpty || filterText == "" || filterText == " "{
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
        
        return cell

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFiltering{
            if let hexcode = filteredArray()[indexPath.row].hexcode{
                let imageName = "stickers/\(hexcode)"
                //print(imageName)
                
                // Configure the cell
                if let stickerImage = UIImage(named: imageName){
                    UIPasteboard.general.image = stickerImage
                    print("Copied image")
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
