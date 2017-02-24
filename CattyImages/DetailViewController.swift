//
//  DetailViewController.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/23/17.
//  Copyright © 2017 WM. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout
import Neon
import SDWebImage
import RxSwift
import RxCocoa
import Agrume

class DetailViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let catty: CTImage
    let catImageView: UIImageView = UIImageView()
    let captionLabel: UILabel = UILabel()
    let titleLabel: UILabel = UILabel()
    let similarLabel: UILabel = UILabel()
    let horiFlowLayout: AnimatedCollectionViewLayout = AnimatedCollectionViewLayout()
    var similarCollectionView: UICollectionView?
    
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

        self.navigationController?.navigationBar.isTranslucent = false
        
        let animator = LinearCardAttributesAnimator(minAlpha: 0.05, itemSpacing: 0.1, scaleRate: 0.9)
        horiFlowLayout.animator = animator
        horiFlowLayout.scrollDirection = .horizontal
        similarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: horiFlowLayout)
        
        catImageView.contentMode = .scaleAspectFit
        self.view.addSubview(catImageView)
        
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 20)
        titleLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(titleLabel)
        
        captionLabel.textAlignment = NSTextAlignment.center
        captionLabel.numberOfLines = 2
        self.view.addSubview(captionLabel)
        
        similarLabel.text = "Similar images:"
        self.view.addSubview(similarLabel)
        
        similarCollectionView?.register(UINib.init(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        similarCollectionView?.backgroundColor = UIColor.white
        self.view.addSubview(similarCollectionView!)
        
        catImageView.anchorAndFillEdge(.top, xPad: 10, yPad: 10, otherSize: self.view.frame.size.height/2)
        titleLabel.alignAndFillWidth(align: .underCentered, relativeTo: catImageView, padding: 0, height: 25)
        captionLabel.alignAndFillWidth(align: .underCentered, relativeTo: titleLabel, padding: 0, height: 40)
        similarLabel.alignAndFillWidth(align: .underCentered, relativeTo: captionLabel, padding: 0, height: 20)
        similarCollectionView?.alignAndFillWidth(align: .underCentered, relativeTo: similarLabel, padding: 10, height: (self.view.frame.size.width / 3)+10)
        
    }
    
    func setupRx() {
        viewModel.title.bindTo(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.title.bindTo(captionLabel.rx.text).disposed(by: disposeBag)
        viewModel.uri.distinctUntilChanged().subscribe{ u -> Void in
            if let url = u.element {
                self.catImageView.sd_setImage(with: url)
            }
            }.disposed(by: disposeBag)
        
        similarCollectionView?.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.similarImageList
            .bindTo(similarCollectionView!.rx.items(cellIdentifier: "Cell")) {
                (index, ctimage: CTImage, cell: FeedCollectionViewCell) in
                let strurl = (ctimage.sizes.first?.strUri)!
                let enstrurl = (strurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
                
                cell.nameLabel.text = ctimage.title
                cell.imageView.sd_setImage(with: URL.init(string: enstrurl), placeholderImage: UIImage.init(named: "octocat"))
            }.disposed(by: disposeBag)
        
        similarCollectionView?.rx.modelSelected(CTImage.self)
            .subscribe {
                ctimage in
                let strurl = (ctimage.element?.sizes.first?.strUri)!
                let enstrurl = (strurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
                let uri = URL.init(string: enstrurl)!
                let agrume = Agrume(imageUrl: uri)
                agrume.showFrom(self)
            }.disposed(by: disposeBag)
        
    }
    
    //MARK: - CollecitonView Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width / 3)
        return CGSize(width: size, height: size)
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
