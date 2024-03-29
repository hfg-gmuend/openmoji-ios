//
//  StickersManager.swift
//  OpenMoji
//
//  Created by Sam Eckert on 29.03.24.
//  Copyright © 2024 OpenMoji. All rights reserved.
//

import Foundation

class StickersManager {
    static let shared = StickersManager()
    private let userDefaults = UserDefaults.standard
    var stickersArray: [Sticker] = []
    var filteredStickersArray: [Sticker] = []
    private let recentStickersKey = "recentStickers"

    private init() {} // Makes this a singleton class

    func getDataFromJSON(completion: @escaping (Bool) -> Void) {
        // Include the JSON parsing logic here
        if let jsonFilePath = Bundle.main.url(forResource: "openmoji", withExtension: "json"){
            do{
                let decoder = JSONDecoder()
                
                let jsonFileData = try Data(contentsOf: jsonFilePath)
                let stickers: [Sticker] = try decoder.decode([Sticker].self, from: jsonFileData)
                stickersArray = stickers
                filteredStickersArray = stickers
                
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
                        // Not working
                        print("stickersArray.count before removing base versions is: \(stickersArray.count)")
                        
                        // Removes all yellow skin color emojis
                        filteredStickersArray.removeAll(where: {
                            $0.hexcode == $0.skintoneBaseHexcode
                        })
                        
                        print("stickersArray.count after removing base versions is: \(stickersArray.count)")

                        
                        // Gets rid of all other unwanted skin colors
                        for skinTone in skinToneModifiers{
                            filteredStickersArray.removeAll(where: {
                                $0.hexcode?.contains("-"+skinTone) == true
                            })
                        }
                    }else{
                        // Gets rid of all other unwanted skin colors
                        for skinTone in skinToneModifiers{
                            filteredStickersArray.removeAll(where: {
                                $0.hexcode?.contains("-"+skinTone) == true
                            })
                        }
                    }
                    
                    filteredStickersArray.removeAll(where: {
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

    // Add any additional methods you might need, e.g., filtering stickers
    
    
    // MARK: - Recent Stickers using Hexcodes
        func addRecentSticker(_ sticker: Sticker) {
            guard let hexcode = sticker.hexcode else { return }
            
            var recentStickersHexcodes = getRecentStickersHexcodes()
            recentStickersHexcodes.insert(hexcode, at: 0) // Add to the beginning of the array
            // Limit the size of the array to 20 items (assuming you wanted 20, though you've mentioned 100 in your code)
            recentStickersHexcodes = Array(recentStickersHexcodes.prefix(20))
            
            print(recentStickersHexcodes)
            
            // Save the array of hexcodes to UserDefaults
            userDefaults.set(recentStickersHexcodes, forKey: recentStickersKey)
        }

        func getRecentStickersHexcodes() -> [String] {
            // Retrieve and return the array of hexcodes
            return userDefaults.stringArray(forKey: recentStickersKey) ?? []
        }

        // Assuming you have a method to convert hexcodes back to Stickers
        func getRecentStickers() -> [Sticker] {
            let hexcodes = getRecentStickersHexcodes()
            let stickers = hexcodes.compactMap { hexcode -> Sticker? in
                // Implement logic to convert hexcode back to Sticker
                // For example, find the sticker in stickersArray with this hexcode
                return stickersArray.first { $0.hexcode == hexcode }
            }
            return stickers
        }
}
