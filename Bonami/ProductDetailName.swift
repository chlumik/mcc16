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

class ProductDetailName: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25))
        }
        
        contentView.addSubview(customSeparator)
        customSeparator.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(nameLabel)
            make.bottom.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }

    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(20.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    let customSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        
        return view
    }()
}