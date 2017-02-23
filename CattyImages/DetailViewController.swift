//
//  DetailViewController.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/23/17.
//  Copyright © 2017 WM. All rights reserved.
//

import UIKit
import Neon
import SDWebImage
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    let catty: CTImage
    let catImageView: UIImageView = UIImageView()
    let captionLabel: UILabel = UILabel()
    let titleLabel: UILabel = UILabel()
    let similarCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let disposeBag = DisposeBag()
    
    lazy var viewModel: DetailViewModel = {
        return DetailViewModel(ctimage: self.catty)
    }()
    
    init(catty: CTImage)
    {
        self.catty = catty
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()

        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.white
        catImageView.sd_setImage(with: viewModel.uri)
        catImageView.contentMode = .scaleAspectFit
        self.view.addSubview(catImageView)
        
        viewModel.title.bindTo(titleLabel.rx.text)
//        titleLabel.text = viewModel.title
        titleLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(titleLabel)
        
        captionLabel.text = viewModel.caption
        captionLabel.textAlignment = NSTextAlignment.center
        captionLabel.numberOfLines = 2
        self.view.addSubview(captionLabel)
        
        similarCollectionView.register(UINib.init(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        similarCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(similarCollectionView)
        
        catImageView.anchorAndFillEdge(.top, xPad: 10, yPad: 10, otherSize: self.view.frame.size.height/2)
        titleLabel.alignAndFillWidth(align: .underCentered, relativeTo: catImageView, padding: 0, height: 20)
        captionLabel.alignAndFillWidth(align: .underCentered, relativeTo: titleLabel, padding: 0, height: 40)
        similarCollectionView.alignAndFill(align: .underCentered, relativeTo: captionLabel, padding: 0)
    }
    
    func setupRx() {
        viewModel.similarImageList
            .bindTo(similarCollectionView.rx.items(cellIdentifier: "Cell")) {
                (index, ctimage: CTImage, cell: FeedCollectionViewCell) in
                let strurl = (ctimage.sizes.first?.strUri)!
                let enstrurl = (strurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
                
                cell.nameLabel.text = ctimage.title
                cell.imageView.sd_setImage(with: URL.init(string: enstrurl), placeholderImage: UIImage.init(named: "octocat"))
            }.disposed(by: disposeBag)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
