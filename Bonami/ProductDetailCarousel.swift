//
//  ProductDetailCell.swift
//  Bonami
//
//  Created by Praženica Andrej on 21/05/16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ProductDetailCarousel: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    var images: [ProductImage]! {
        didSet {
            carousel.reloadData()
        }
    }
    
    var carousel: MCRotatingCarousel!
    
    var targetImageSize: CGRect! {
        didSet {
            carousel.reloadData()
        }
    }
    
    // MARK: - View Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .whiteColor()
        
        // photo in carousel size, needs to be updated for responsibility
        let size = UIScreen.mainScreen().bounds.height / 3
        let margin: CGFloat = 20
        targetImageSize = CGRect(x: 0, y: 0, width: size - margin, height: size - margin)
        
        carousel = MCRotatingCarousel(frame: self.frame)
        carousel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        carousel.dataSource = self
        
        carousel.pageControl.currentPageIndicatorTintColor = UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 1.0)
        carousel.pageControl.pageIndicatorTintColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        self.addSubview(carousel)
        
        // FIXME: iPad responsiveness!
        self.contentView.snp_makeConstraints { make in
            make.height.equalTo(UIScreen.mainScreen().bounds.height / 2)
        }
    }
    
    func redoConstraints(newSize: CGSize) {
        self.contentView.snp_remakeConstraints { make in
            make.height.equalTo(newSize.height / 2)
        }
    }
}

extension ProductDetailCarousel: MCRotatingCarouselDataSource {
    func numberOfItemsInRotatingCarousel(carousel: MCRotatingCarousel!) -> UInt {
        return UInt(images.count)
    }
    
    func rotatingCarousel(carousel: MCRotatingCarousel!, viewForItemAtIndex index: UInt) -> UIView! {
        let photo = UIImageView()
        photo.frame = targetImageSize
        
        // V případě že nedostaneme obrázek, umístíme placeholder
        
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .Gray
        photo.addSubview(indicator)
        indicator.snp_makeConstraints { make in
            make.center.equalTo(photo)
        }
        indicator.startAnimating()
        indicator.hidden = false
        photo.sd_setImageWithURL(NSURL(string: images[Int(index)].productDetailThumbnailRetina)) { image, error, cacheType, imageURL in
            if let _ = error {
                indicator.removeFromSuperview()
                indicator.hidden = true
                indicator.stopAnimating()
                photo.image = UIImage.imageWithColor(.whiteColor(), size: CGSize(width: 200, height: 200))
            }
            
            indicator.removeFromSuperview()
            indicator.hidden = true
            indicator.stopAnimating()
        }
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        photo.layer.shadowColor = UIColor.blackColor().CGColor
        photo.layer.shadowOpacity = 0.15
        photo.layer.shadowRadius = 2.0
        photo.layer.shadowOffset = CGSizeMake(0, 0);
        photo.clipsToBounds = false
        
        return photo
    }
}