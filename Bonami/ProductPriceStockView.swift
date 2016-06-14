//
//  ProductPriceStockView.swift
//  Bonami
//
//  Created by Jan Nejtek on 25/05/16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit


class ProductPriceStockView: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    var priceInfo: ProductPriceInfo! {
        didSet {
            let price = BonamiFormatCurrency(priceInfo.price, currency: priceInfo.currency)
            let retailPrice = BonamiFormatCurrency(priceInfo.retailPrice, currency: priceInfo.retailPriceCurrency)
            
            setPriceLabel(price, retailPrice: retailPrice)
        }
    }
    var stockInfo: ProductStockInfo! {
        didSet {
            
            // produkt k dispozici
            if stockInfo.stockType == "available" {
                self.backgroundColor = UIColor(red: 0.17, green: 0.81, blue: 0.36, alpha: 1.0)
                
                // produkt má stockWarning
                if let warning = stockInfo.stockWarning {
                    warningContainer.hidden = false
                    warningLabel.text = warning.uppercaseString
                } else {
                    warningContainer.hidden = true
                    warningLabel.text = ""
                }
                
                // produkt má stockInfoText
                if let infoText = stockInfo.stockInfoText {
                    infoContainer.hidden = false
                    infoLabel.text = infoText
                } else {
                    infoContainer.hidden = true
                    infoLabel.text = ""
                }
            }
            
            // produkt vyprodán nebo něco jiného
            else {
                self.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                
                infoContainer.hidden = true
                
                if stockInfo.stockType == "soldOut" {
                    warningContainer.hidden = false
                    warningLabel.text = NSLocalizedString("product_soldOut", comment: "Popisek 'Vyprodáno' v SingleCampaignView a ProductDetailView").uppercaseString
                } else if stockInfo.stockType == "reserved" {
                    warningContainer.hidden = false
                    warningLabel.text = NSLocalizedString("product_reserved", comment: "Popisek 'Rezervováno' v SingleCampaignView a ProductDetailView").uppercaseString
                } else {
                    print("ProductPriceStockView: neznámý stocktype \(stockInfo.stockType)!")
                    warningContainer.hidden = true
                    warningLabel.text = ""
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(priceLabel)
        priceLabel.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp_left).offset(25)
        }
        
        addSubview(infoWarningContainer)
        
        warningContainer.addSubview(warningLabel)
        warningLabel.snp_makeConstraints { make in
            make.edges.equalTo(warningContainer).inset(4)
        }
        
        infoContainer.addSubview(infoLabel)
        infoLabel.snp_makeConstraints { make in
            make.edges.equalTo(infoContainer).inset(4)
        }
        
        infoWarningContainer.addSubview(warningContainer)
        infoWarningContainer.addSubview(infoContainer)
        warningContainer.snp_makeConstraints { make in
            make.top.equalTo(infoWarningContainer.snp_top)
            make.left.equalTo(infoWarningContainer.snp_left)
        }
        infoContainer.snp_makeConstraints { make in
            make.top.equalTo(warningContainer.snp_bottom).offset(4)
            make.left.equalTo(infoWarningContainer)
        }
        
        infoWarningContainer.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self.snp_right).inset(25)
            make.bottom.equalTo(infoContainer.snp_bottom)
            make.width.greaterThanOrEqualTo(warningContainer)
            make.width.greaterThanOrEqualTo(infoContainer)
        }
        
        // SnapKit se rozhodl že greaterThanOrEqualTo znamená maximumAvailable, proto tohle
        if infoWarningContainer.frame.height > priceLabel.frame.height {
            self.snp_makeConstraints { make in
                make.height.equalTo(infoWarningContainer).multipliedBy(1.5)
            }
        } else {
            self.snp_makeConstraints { make in
                make.height.equalTo(priceLabel).multipliedBy(1.5)
            }
        }
    }
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.numberOfLines = 1
        
        return label
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.numberOfLines = 1
        label.font = UIFont.systemFontOfSize(13.5, weight: UIFontWeightBold)
        
        return label
    }()
    
    let warningContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .redColor()
        container.layer.cornerRadius = 5.0
        container.layer.masksToBounds = true
        
        return container
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.numberOfLines = 1
        label.font = UIFont.systemFontOfSize(13.5, weight: UIFontWeightBold)
        
        return label
    }()
    
    let infoContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.17, green: 0.81, blue: 0.36, alpha: 1.0)
        container.layer.borderColor = UIColor.whiteColor().CGColor
        container.layer.borderWidth = 1.0
        container.layer.cornerRadius = 5.0
        container.layer.masksToBounds = true
        
        return container
    }()
    
    let infoWarningContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clearColor()
        
        return container
    }()
    
    func setPriceLabel(price: String, retailPrice: String?) {
        let bold_attribs = [NSFontAttributeName: UIFont.systemFontOfSize(18.0, weight: UIFontWeightBold)]
        
        guard let oldPrice = retailPrice else {
            let price_text = NSAttributedString(string: price, attributes: bold_attribs)
            
            priceLabel.numberOfLines = 1
            priceLabel.attributedText = price_text
            return
        }
        
        let price_text = NSMutableAttributedString(string: price, attributes: bold_attribs)
        
        let strike_attribs = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        price_text.appendAttributedString(NSAttributedString(string: "\n"))
        price_text.appendAttributedString(NSAttributedString(string: oldPrice, attributes: strike_attribs))
        
        priceLabel.numberOfLines = 2
        priceLabel.attributedText = price_text
    }
}
