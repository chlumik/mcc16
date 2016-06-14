//
//  SingleProductCell.swift
//  Bonami
//
//  Created by Jan Nejtek on 14.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit

class SingleProductCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Properties
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .whiteColor()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.clipsToBounds = false
        
        addSubview(priceLabel)
        priceLabel.snp_makeConstraints { make in
            make.bottom.equalTo(self).offset(-10)
            make.leftMargin.equalTo(10)
        }
        
        addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.width.equalTo(self).inset(10)
            make.centerX.equalTo(self)
            make.height.equalTo(70)
            make.bottom.equalTo(priceLabel.snp_top).offset(-10)
        }
        
        addSubview(productPhotoView)
        productPhotoView.snp_makeConstraints{ make in
            make.width.equalTo(self).inset(10)
            make.height.equalTo(productPhotoView.snp_width)
            make.centerX.equalTo(self)
            make.top.equalTo(10)
        }
        
        addSubview(photoLoadIndicator)
        photoLoadIndicator.snp_makeConstraints { make in
            make.center.equalTo(productPhotoView)
        }
        
        warningContainer.addSubview(warningLabel)
        warningLabel.snp_makeConstraints { make in
            make.edges.equalTo(warningContainer).inset(4)
        }
        
        addSubview(warningContainer)
        warningContainer.snp_makeConstraints { make in
            make.left.equalTo(productPhotoView)
            make.top.equalTo(productPhotoView.snp_bottom).offset(-12)
            make.width.lessThanOrEqualTo(productPhotoView)
        }
    }
    
    
    
    // MARK: - setView
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(13.75)
        
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFontOfSize(14.5)
        label.font = UIFont.systemFontOfSize(14.5, weight: UIFontWeightBold)
        
        return label
    }()
    
    let productPhotoView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .ScaleAspectFit
        imageview.clipsToBounds = true
        
        return imageview
    }()
    
    let photoLoadIndicator: UIActivityIndicatorView = {
        let indicatorview = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicatorview.color = .grayColor()
        
        return indicatorview
    }()
    
    let warningContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .redColor()
        container.layer.cornerRadius = 5.0
        container.layer.masksToBounds = true
        
        return container
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(11.5, weight: UIFontWeightBold)
        label.numberOfLines = 1
        
        return label
    }()
}