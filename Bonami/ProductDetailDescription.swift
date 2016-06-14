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

class ProductDetailDescription: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25))
        }
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Justified
        label.numberOfLines = 0
        
        return label
    }()
}