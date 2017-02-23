//
//  FeedCollectionViewCellModel.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/23/17.
//  Copyright © 2017 WM. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct DetailViewModel {
    let title: Observable<String>
    let uri: URL
    let caption: String
    let assetId: String
    
    var similarImageList: Observable<[CTImage]> {
        return title
            .observeOn(MainScheduler.instance)
            .flatMapLatest { text -> Observable<CTImageList> in
                return self.getImages(txt: text)
            }.flatMapLatest { li -> Observable<[CTImage]> in
                return self.getCTImages(imglist: li)
            }.catchErrorJustReturn([])
    }
    
    func getImages(txt: String) -> Observable<CTImageList> {
        return GettyProvider.request(.similar(assetId: txt)).mapObject(CTImageList.self)
    }
    
    func getCTImages(imglist: CTImageList) -> Observable<[CTImage]> {
        return Observable.from(imglist.images)
    }
    
    init(ctimage: CTImage) {
        title = Observable.from(ctimage.title)
        assetId = ctimage.imageId
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
