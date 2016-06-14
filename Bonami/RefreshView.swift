//
//  RefreshView.swift
//  Bonami
//
//  Created by Jiří Chlum on 26.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit

import SnapKit

class RefreshView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "BonamiSymbol")
    }
}
