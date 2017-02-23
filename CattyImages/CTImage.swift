//
//  CTImage.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/22/17.
//  Copyright © 2017 WM. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - CTImageList

class CTImageList: Mappable {
    var images: [CTImage]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        images <- map["images"]
    }
}

//MARK - CTImage

class CTImage: Mappable {
    var imageId: String!
    var uri: URL!
    var sizes: [CISize]!
    var title: String!
    var caption: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        imageId    <- map["id"]
        uri <- map["display_sizes.0.uri"]
        sizes <- map["display_sizes"]
        title <- map["title"]
        caption <- map["caption"]
    }
}

//MARK: - CISize

class CISize: Mappable {
    var strUri: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        name <- map["name"]
        strUri <- map["uri"]
    }
}
