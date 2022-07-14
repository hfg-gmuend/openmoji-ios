//
//  Sticker.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 4, 2019


import Foundation

struct Sticker: Codable {
    
    public var annotation : String?
    public var emoji : String?
    public var group : String?
    public var hexcode : String?
    public var openmojiAuthor : String?
    public var openmojiDate : String?
    public var openmojiTags : String?
    public var order : Int?
    public var skintone : String?
    public var skintoneCombination : String?
    public var skintoneBaseEmoji : String?
    public var skintoneBaseHexcode : String?
    public var subgroups : String?
    public var tags : String?
    public var unicode : Float?
    
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

/*extension Sticker: Codable {
    init(from decoder: Decoder) throws {
        annotation = try decoder.decode("annotation")
        emoji = try decoder.decode("emoji")
        group = try decoder.decode("group")
        hexcode = try decoder.decode("hexcode")
        openmojiAuthor = try decoder.decode("openmoji_author")
        openmojiDate = try decoder.decode("openmoji_date")
        openmojiTags = try decoder.decode("openmoji_tags")
        order = try decoder.decode("order")
        skintone = try decoder.decode("skintone")
        skintoneCombination = try decoder.decode("skintone_combination")
        skintoneBaseEmoji = try decoder.decode("skintone_base_emoji")
        skintoneBaseHexcode = try decoder.decode("skintone_base_hexcode")
        subgroups = try decoder.decode("subgroups")
        tags = try decoder.decode("tags")
        unicode = try decoder.decode("unicode")
    }
}*/
