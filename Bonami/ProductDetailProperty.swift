//
//  ProductDetailCell.swift
//  Bonami
//
//  Created by Praženica Andrej on 21/05/16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit

class ProductDetailProperty: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(propertyValueLabel)
        propertyValueLabel.snp_makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).inset(15)
            make.trailing.equalTo(contentView).inset(25)
        }
        
        contentView.addSubview(propertyNameLabel)
        propertyNameLabel.snp_makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).inset(15)
            make.leading.equalTo(contentView).inset(25)
            make.trailing.equalTo(propertyValueLabel.snp_leading).offset(-10)
        }
        
        contentView.addSubview(customSeparator)
        customSeparator.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(contentView).inset(25)
            make.bottom.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
    }
    
    let propertyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.0)
        label.numberOfLines = 1
        
        return label
    }()
    
    let propertyValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.0)
        label.numberOfLines = 1
        label.textAlignment = .Right
        
        return label
    }()
    
    let customSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        
        return view
    }()
}