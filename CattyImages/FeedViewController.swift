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

class FeedViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UISearchBarDelegate {
    
    let catCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let searchBar: UISearchBar = UISearchBar()
    let containerView: UIView = UIView()
    let noresLabel:UILabel = UILabel()
    
    let viewModel = FeedViewModel()
    
    //TODO: bind rx
    private var cattyImages: CTImageList?
    
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
        searchBar.delegate = self

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        noresLabel.fillSuperview()
        catCollectionView.fillSuperview()
    }

    func setupRx() {
//        let disposeBag = DisposeBag()
        self.searchBar.rx.text
            .orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bindTo(viewModel.searchText)
        
        viewModel.imageList
            .bindTo(catCollectionView.rx.items(cellIdentifier: "Cell")) {
                (index, ctimage: CTImage, cell: FeedCollectionViewCell) in
                let strurl = (ctimage.sizes.first?.strUri)!
                let enstrurl = (strurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
                
                cell.nameLabel.text = ctimage.title
                cell.imageView.sd_setImage(with: URL.init(string: enstrurl), placeholderImage: UIImage.init(named: "octocat"))
        }
        
        catCollectionView.rx.modelSelected(CTImage.self)
            .subscribe {
                ctimage in
                let detailViewController = DetailViewController(catty: ctimage.element!)
                self.navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        catCollectionView.rx.setDelegate(self)
        
    }
    
//    func searchCat(searchText: String) {
//        GettyProvider.request(.images(phrase: searchText))
//            .mapObject(CTImageList.self)
//            .subscribe { event -> Void in
//                switch event {
//                case .next(let images):
//                    //TODO: Propery binds cattyImages, eg RAC(self, catty = RACObserv..... need to learn the rx syntax :<
//                    self.cattyImages = images
//                    if self.cattyImages?.images.count == 0 {
//                        UIView.animate(withDuration: 0.7, animations: {
//                            self.catCollectionView.alpha = 0
//                        }, completion: { (Bool) in
//                            self.catCollectionView.isHidden = true
//                        })
//                        
//                    } else {
//                        self.catCollectionView.isHidden = false
//                        UIView.animate(withDuration: 0.7, animations: {
//                            self.catCollectionView.alpha = 1
//                        }, completion: { (Bool) in
//                            
//                        })
//                    }
//                    self.catCollectionView.reloadData()
//                case .error(let error):
//                    print(error)
//                default:
//                    break
//                }
//        }
//    }
    
    //MARK: - CollecitonView Delegate, Datasource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width / 3) - 7
        return CGSize(width: size, height: size)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    //MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
