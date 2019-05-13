//
//  Sticker.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 4, 2019


import Foundation
import Unbox

struct Sticker: Unboxable {
    
    public var annotation : String?
    public var emoji : String?
    public var group : String?
    public var hexcode : String?
    public var openmojiAuthor : String?
    public var openmojiDate : String?
    public var openmojiTags : String?
    public var order : String?
    public var skintone : String?
    public var skintoneCombination : String?
    public var skintoneBaseEmoji : String?
    public var skintoneBaseHexcode : String?
    public var subgroups : String?
    public var tags : String?
    public var unicode : String?
    
    init(unboxer: Unboxer) throws {
        annotation = try unboxer.unbox(key: "annotation")
        emoji = try unboxer.unbox(key: "emoji")
        group = try unboxer.unbox(key: "group")
        hexcode = try unboxer.unbox(key: "hexcode")
        openmojiAuthor = try unboxer.unbox(key: "openmoji_author")
        openmojiDate = try unboxer.unbox(key: "openmoji_date")
        openmojiTags = try unboxer.unbox(key: "openmoji_tags")
        order = try unboxer.unbox(key: "order")
        skintone = try unboxer.unbox(key: "skintone")
        skintoneCombination = try unboxer.unbox(key: "skintone_combination")
        skintoneBaseEmoji = try unboxer.unbox(key: "skintone_base_emoji")
        skintoneBaseHexcode = try unboxer.unbox(key: "skintone_base_hexcode")
        subgroups = try unboxer.unbox(key: "subgroups")
        tags = try unboxer.unbox(key: "tags")
        unicode = try unboxer.unbox(key: "unicode")
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if annotation != nil{
            dictionary["annotation"] = annotation
        }
        if emoji != nil{
            dictionary["emoji"] = emoji
        }
        if group != nil{
            dictionary["group"] = group
        }
        if hexcode != nil{
            dictionary["hexcode"] = hexcode
        }
        if openmojiAuthor != nil{
            dictionary["openmoji_author"] = openmojiAuthor
        }
        if openmojiDate != nil{
            dictionary["openmoji_date"] = openmojiDate
        }
        if openmojiTags != nil{
            dictionary["openmoji_tags"] = openmojiTags
        }
        if order != nil{
            dictionary["order"] = order
        }
        if skintone != nil{
            dictionary["skintone"] = skintone
        }
        if skintoneCombination != nil{
            dictionary["skintoneCombination"] = skintoneCombination
        }
        if skintoneBaseEmoji != nil{
            dictionary["skintone_base_emoji"] = skintoneBaseEmoji
        }
        if skintoneBaseHexcode != nil{
            dictionary["skintone_base_hexcode"] = skintoneBaseHexcode
        }
        if subgroups != nil{
            dictionary["subgroups"] = subgroups
        }
        if tags != nil{
            dictionary["tags"] = tags
        }
        if unicode != nil{
            dictionary["unicode"] = unicode
        }
        return dictionary
    }
    
}
