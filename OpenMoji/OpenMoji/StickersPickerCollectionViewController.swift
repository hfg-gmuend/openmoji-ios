//
//  StickersPickerCollectionViewController.swift
//  OpenMoji
//
//  Created by Sam Eckert on 04.04.19.
//  Copyright © 2019 OpenMoji. All rights reserved.
//

import UIKit
import Unbox

class StickersPickerCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    private let reuseIdentifier = "StickerCell"
    private let itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    
    var stickersArray = [Sticker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDataFromJSON { (successfullyParsed) in
            if successfullyParsed{
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
            }else{
                self.collectionView.isHidden = true
            }
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Data
    func getDataFromJSON(completion: (Bool) -> Void){
        if let jsonFilePath = Bundle.main.url(forResource: "openmoji", withExtension: "json"){
            //if let jsonFile = FileManager.reso
            
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return stickersArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StickersPickerCollectionViewCell
    
        if let hexcode = stickersArray[indexPath.row].hexcode{
            let imageName = "stickers/\(hexcode)"
            print(imageName)
            
            // Configure the cell
            if let stickerImage = UIImage(named: imageName){
                cell.imageView.image = stickerImage
            }
            
        }else{
            cell.imageView.image = nil
        }
        
        return cell

    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
