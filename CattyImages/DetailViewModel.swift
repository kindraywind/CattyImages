//
//  FeedCollectionViewCellModel.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/23/17.
//  Copyright © 2017 WM. All rights reserved.
//

import Foundation

struct DetailViewModel {
    let title: String
    let uri: URL
    let caption: String
    
    init(ctimage: CTImage) {
        title = ctimage.title
        let strurl = (ctimage.sizes.first?.strUri)!
        let enstrurl = (strurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
        uri = URL.init(string: enstrurl)!
        if let c = ctimage.caption {
            caption = c
        } else {
            caption = ""
        }
    }
}
