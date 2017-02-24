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

class DetailViewModel {
    let title: Observable<String>
    let uri: Observable<URL>
    let caption: Observable<String>
    let assetId: Observable<String>
    
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
        assetId = Observable.from(ctimage.imageId)
        let strurl = (ctimage.sizes.first?.strUri)!
        let enstrurl = (strurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
        uri = Observable.from(URL.init(string: enstrurl))
        caption = Observable.from(ctimage.caption).catchErrorJustReturn("")
    }

}
