//
//  LogInViewModel.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/22/17.
//  Copyright © 2017 WM. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct FeedViewModel {
    var searchText = Variable<String>("")
    var imageList: Observable<[CTImage]> {
        return searchText
            .asObservable()
            .observeOn(MainScheduler.instance)
            .flatMapLatest { text -> Observable<CTImageList> in
                return self.getImages(txt: text)
            }.flatMapLatest { li -> Observable<[CTImage]> in
                return self.getCTImages(imglist: li)
            }
            
    }
    
    func getImages(txt: String) -> Observable<CTImageList> {
        return GettyProvider.request(.images(phrase: txt)).mapObject(CTImageList.self)
    }
    
    func getCTImages(imglist: CTImageList) -> Observable<[CTImage]> {
        return Observable.from(imglist.images)
    }
    
}
