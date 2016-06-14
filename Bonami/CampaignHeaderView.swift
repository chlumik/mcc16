//
//  CampaignHeaderView.swift
//  Bonami
//
//  Created by Jan Nejtek on 15.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class CampaignHeaderView: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Properties
    
    private let maxDayTime = 50
    
    // MARK: - View init
    
    init(frame: CGRect, imageUrl: String, perex: String, endAt: String) {
        super.init(frame: frame)
        
        let dateEndAt = NSDate.dateFromISOString(endAt)
        
        let sysCalendar: NSCalendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.Hour]
        let breakdown: NSDateComponents = sysCalendar.components(unitFlags, fromDate: NSDate(), toDate: dateEndAt, options: .WrapComponents)
        
        let remainingDays = String(format: NSLocalizedString("remaining_days", comment: ""), breakdown.day)
        let remainingHours = String(format: NSLocalizedString("remaining_hours", comment: ""), breakdown.hour)
        
        let timeRemainingString = " \(remainingDays), \(remainingHours)"
        
        // MARK: Insertion of TimeIcon into timeRemainingLabel via NSAttributedString
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: "TimeIcon")
        attachment.bounds = CGRect(x: -2, y: -1.75, width: 14, height: 14)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let strLabelText: NSAttributedString = NSAttributedString(string: timeRemainingString)
        let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
        mutableAttachmentString.appendAttributedString(strLabelText)
        
        timeRemainingLabel.attributedText = mutableAttachmentString
        
        if breakdown.day > maxDayTime {
            timeRemainingLabel.hidden = true
        }
        
        perexLabel.text = perex
        
        // MARK: View layout
        
        // TODO: sehnat lepší placeholder pro header kampaně
        let placeholderImage: UIImage = UIImage.imageWithColor(.grayColor(), size: CGSize(width: 600, height: 300))
        backgroundImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: placeholderImage) { image, error, cacheType, imageURL in
            let dark_img = image.darkenedImage(0.4)
            self.backgroundImageView.image = dark_img
        }
        addSubview(backgroundImageView)
        addSubview(blurContainerView)
        addSubview(timeRemainingLabel)
        addSubview(perexLabel)
        addSubview(bonamiLogoView)
        
        perexLabel.sizeToFit()
        
        backgroundImageView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        blurContainerView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        perexLabel.snp_makeConstraints { make in
            make.centerX.equalTo(backgroundImageView)
            make.centerY.equalTo(backgroundImageView).multipliedBy(1.4).offset(-2.5)
            make.width.equalTo(backgroundImageView)
        }
        timeRemainingLabel.snp_makeConstraints { make in
            make.centerX.equalTo(backgroundImageView)
            make.centerY.equalTo(backgroundImageView).multipliedBy(1.65).offset(5.0)
            make.width.equalTo(backgroundImageView)
        }
        bonamiLogoView.snp_makeConstraints { make in
            make.top.equalTo(self).offset(82)
            make.height.equalTo(35)
            make.centerX.equalTo(self)
        }
    }
    
    // MARK: - setView
    
    let perexLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
        label.textAlignment = .Center
        label.numberOfLines = 2
        
        return label
    }()
    
    let timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(13.0)
        
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let blurContainerView: UIView = {
        let container = UIView()
        let effect: UIVisualEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effectView = UIVisualEffectView(effect: effect)
        container.alpha = 0.0
        
        container.addSubview(effectView)
        effectView.snp_makeConstraints { make in
            make.edges.equalTo(container)
        }
        
        return container
    }()
    
    let bonamiLogoView: UIImageView = {
        let imageView = UIImageView()
        let tintedImage = UIImage(named: "BonamiLogo")?.imageWithRenderingMode(.AlwaysTemplate)
        imageView.image = tintedImage
        imageView.tintColor = UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)
        imageView.contentMode = .ScaleAspectFit
        
        return imageView
    }()
}
