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

class DetailViewController: UIViewController {
    
    let catty: CTImage
    let catImageView: UIImageView = UIImageView()
    let captionLabel: UILabel = UILabel()
    let titleLabel: UILabel = UILabel()
    
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

        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.white
//        let strurl = (self.catty.sizes.first?.strUri)!
//        let enstrurl = (viewModel.uri.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed))!
        catImageView.sd_setImage(with: viewModel.uri)
        catImageView.contentMode = .scaleAspectFit
        self.view.addSubview(catImageView)
        
        titleLabel.text = viewModel.title
        titleLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(titleLabel)
        
        captionLabel.text = viewModel.caption
        captionLabel.textAlignment = NSTextAlignment.center
        captionLabel.numberOfLines = 2
        self.view.addSubview(captionLabel)
        
        catImageView.anchorAndFillEdge(.top, xPad: 10, yPad: 10, otherSize: self.view.frame.size.height/2)
        titleLabel.alignAndFillWidth(align: .underCentered, relativeTo: catImageView, padding: 20, height: 40)
        captionLabel.alignAndFillWidth(align: .underCentered, relativeTo: titleLabel, padding: 20, height: 60)
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
