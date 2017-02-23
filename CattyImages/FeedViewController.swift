//
//  FeedViewController.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/22/17.
//  Copyright © 2017 WM. All rights reserved.
//

import Moya
import Moya_ObjectMapper
import Neon
import RxSwift
import RxCocoa
import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let catCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let searchBar: UISearchBar = UISearchBar()
    let containerView: UIView = UIView()
    let noresLabel:UILabel = UILabel()
    
    let viewModel = FeedViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        setupRx()
    }
    
    func setupUI() {
        self.title = "catty"
        self.navigationController?.navigationBar.isTranslucent = false
        
        noresLabel.text = "No result meaw...."
        noresLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(noresLabel)
        
        catCollectionView.register(UINib.init(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        catCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(catCollectionView)
        
        searchBar.placeholder = "...anything about cat..."
        searchBar.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width-20, height: 44)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        noresLabel.fillSuperview()
        catCollectionView.fillSuperview()
    }

    func setupRx() {
        self.searchBar.rx.text
            .orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bindTo(viewModel.searchText).disposed(by: disposeBag)
        
        viewModel.imageList
            .bindTo(catCollectionView.rx.items(cellIdentifier: "Cell")) {
                (index, ctimage: CTImage, cell: FeedCollectionViewCell) in
                let strurl = (ctimage.sizes.first?.strUri)!
                let enstrurl = (strurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
                
                cell.nameLabel.text = ctimage.title
                cell.imageView.sd_setImage(with: URL.init(string: enstrurl), placeholderImage: UIImage.init(named: "octocat"))
        }.disposed(by: disposeBag)
        
        viewModel.collectionViewShouldHideIfNoItem.bindTo(catCollectionView.rx.isHidden).disposed(by: disposeBag)
        
        catCollectionView.rx.modelSelected(CTImage.self)
            .subscribe {
                ctimage in
                let detailViewController = DetailViewController(catty: ctimage.element!)
                self.navigationController?.pushViewController(detailViewController, animated: true)
        }.disposed(by: disposeBag)
        
        catCollectionView.rx.didScroll.subscribe { _ in
            self.searchBar.endEditing(true)
        }.disposed(by: disposeBag)
        
        catCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //MARK: - CollecitonView Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width / 3) - 7
        return CGSize(width: size, height: size)
    }
    
    //MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
