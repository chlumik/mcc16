//
//  AllCampaignsCell.swift
//  Bonami
//
//  Created by Jiří Chlum on 12.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit

private let maxDayTime = 50
class AllCampaignsCell: UICollectionViewCell {
    
    // MARK: - Model
    
    var campaign: Campaign! {
        didSet {
            campaignNameLabel.text = campaign.name
            descriptionLabel.text = getRightDescriptionFrom(campaign.perex)
            timeRemainingLabel.attributedText = getNSAttibutedStringFrom(string: campaign.endAt!)
            let plh = UIImage.imageWithColor(.grayColor(), size: CGSize(width: 618, height: 298))
            imageView.sd_setImageWithURL(NSURL(string: campaign.images.homepageRetina!), placeholderImage: plh) { image, error, cacheType, imageURL in
                guard (error == nil) else {
                    self.imageView.image = plh
                    return
                }
                let dark_img = image.darkenedImage(0.4)
                self.imageView.image = dark_img
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOpacity = 0.15
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOffset = CGSizeMake(0, 0);
        contentView.clipsToBounds = false
        
        contentView.addSubview(stackView)
        contentView.addSubview(campaignNameLabel)
        contentView.addSubview(timeRemainingLabel)
        contentView.backgroundColor = .whiteColor()
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionLabelView)
        
        descriptionLabelView.addSubview(descriptionLabel)
        
        stackView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        campaignNameLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(imageView.snp_bottom).offset(-10)
            make.leading.equalTo(imageView).offset(10)
            make.trailing.equalTo(imageView).offset(-10)
        }
        
        timeRemainingLabel.snp_makeConstraints { make in
            make.top.equalTo(imageView).offset(10)
            make.trailing.equalTo(imageView).offset(-10)
        }
        
        descriptionLabel.snp_makeConstraints { (make) in
            make.top.equalTo(descriptionLabelView.snp_top).offset(10)
            make.bottom.equalTo(descriptionLabelView.snp_bottom).offset(-10)
            make.leading.equalTo(descriptionLabelView).offset(10)
            make.trailing.equalTo(descriptionLabelView).offset(-10)
        }
    }
    
    // MARK: - setView
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        return stackView
    }()
    
    let campaignNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .whiteColor()
        label.font = UIFont.boldSystemFontOfSize(22)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(18)
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14.0)
        
        return label
    }()
    
    let descriptionLabelView: UIView = {
        let dLV = UIView()
        dLV.backgroundColor = .clearColor()
        return dLV
    }()
    
    // Helper method
    
    func getRightDescriptionFrom(description: String) -> String {
        if description.characters.count < 5 {
            return ""
        }
        return description
    }
    
    func getTimeRemainingString(dateString string: String) -> String? {
        
        let dateEndAt = NSDate.dateFromISOString(string)
        
        let sysCalendar: NSCalendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.Hour]
        let breakdown: NSDateComponents = sysCalendar.components(unitFlags, fromDate: NSDate(), toDate: dateEndAt, options: .WrapComponents)
        if breakdown.day > maxDayTime { return nil }
        let remainingDays = String(format: NSLocalizedString("remaining_days", comment: ""), breakdown.day)
        let remainingHours = String(format: NSLocalizedString("remaining_hours", comment: ""), breakdown.hour)
        
        return " \(remainingDays), \(remainingHours)"
    }
    
    func getNSAttibutedStringFrom(string string: String) -> NSAttributedString {
        
        guard let timeRemainingString = getTimeRemainingString(dateString: string) else { return NSAttributedString() }
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: "TimeIcon")
        attachment.bounds = CGRect(x: 2, y: -1.75, width: 14, height: 14)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let strLabelText: NSAttributedString = NSAttributedString(string: " " + timeRemainingString)
        let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
        mutableAttachmentString.appendAttributedString(strLabelText)
        return mutableAttachmentString
    }
    
    // MARK: - Date handler
}