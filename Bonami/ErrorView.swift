//
//  ErrorView.swift
//  Bonami
//
//  Created by Jiří Chlum on 27.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit

class ErrorView: UIView {
    
    var onRetryButtonClick: (() -> ())!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(errorTextLabel)
        self.addSubview(retryButton)
        
        errorTextLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self)
        }
        
        retryButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(errorTextLabel)
            make.top.equalTo(errorTextLabel.snp_bottom).offset(10)
        }
        
        retryButton.addTarget(self, action: #selector(click), forControlEvents: .TouchUpInside)
    }
    // Přidal lokalizaci
    let errorTextLabel: UILabel = {
        let eTl = UILabel()
        eTl.numberOfLines = 0
        eTl.textAlignment = .Center
        eTl.text = NSLocalizedString("errorText", comment: "Nastala chyba připojení nebo parsování data")
        return eTl
    }()
    
    let retryButton: UIButton = {
        let retry = UIButton()
        retry.setTitleColor(UIColor.blueColor(), forState: .Normal)
        let title = NSLocalizedString("retryButton", comment: "Retry Button")
        retry.setTitle(title, forState: .Normal)
        
        return retry
    }()
    
    func click(sender: UIButton) {
        onRetryButtonClick()
    }
}
