//
//  RecentsCollectionViewController.swift
//  OpenMoji
//
//  Created by Sam Eckert on 29.03.24.
//  Copyright © 2024 OpenMoji. All rights reserved.
//

import UIKit
import SafariServices

class RecentsCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "RecentStickerCell"
    private var itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 20.0,
                                             right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Recently Used"
        if let sourceSansFont = UIFont(name: "SourceSansPro-Bold", size: UIFont.labelFontSize){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: sourceSansFont]
        }
                
        setItemsPerRow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(StickersManager.shared.getRecentStickers())
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
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

        StickersManager.shared.getRecentStickers().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecentStickersCollectionViewCell
    
        if let hexcode = StickersManager.shared.getRecentStickers()[indexPath.row].hexcode{
            let imageName = "stickers/\(hexcode)"
            
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
            cell.imageView.image = nil
            cell.imageView.isHidden = true
            cell.backgroundColor = UIColor.darkGray
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
        
        if let hexcode = StickersManager.shared.getRecentStickers()[indexPath.row].hexcode{
            let imageName = "stickers/\(hexcode)"
            
            // Configure the cell
            if let stickerImage = UIImage(named: imageName){
                lastSharedEmojiName = hexcode
                showShareSheetWith(stickerImage)
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
    
}


extension RecentsCollectionViewController: UICollectionViewDelegateFlowLayout {
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
