//
//  SingleCampaignViewController.swift
//  Bonami
//
//  Created by Jiří Chlum on 10.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SDWebImage

private let cellId = "SingleProductCellId"
class SingleCampaignViewController: UIViewController {
    
    // MARK: - Properties
    var campaign: Campaign!
    private let headerHeight: CGFloat = 120.0
    private let collectionViewMargin: CGFloat = 12.0
    private var page: Int = 1
    private var productCount = 20
    private var isAnotherPage: Bool = true
    
    // MARK: - Model
    var products: [Product] = [] {
        didSet {
            collectionView.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataToModel()
        LoadingOverlay.shared.showOverlay(view)
        self.title = campaign.name
        
        errorView.onRetryButtonClick = { [weak self] Void in
            self!.errorView.removeFromSuperview()
            self?.setDataToModel()
            LoadingOverlay.shared.showOverlay(self?.view)
        }
    }
    
    // MARK: - preparing View
    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .whiteColor()
        view.opaque = true
        self.view = view
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let headerView = CampaignHeaderView(frame: CGRect.zero, imageUrl: campaign.images.homepageRetina!, perex: campaign.perex, endAt: campaign.endAt!)
        collectionView.addSubview(headerView)
        headerView.snp_makeConstraints { make in
            make.top.equalTo(-((headerHeight * 2) + collectionViewMargin))
            make.left.equalTo(-collectionViewMargin)
            make.height.equalTo(headerHeight * 2)
            make.width.equalTo(collectionView)
        }
        
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        self.headerView = headerView
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Layout
    let layout: UICollectionViewFlowLayout = {
        return UICollectionViewFlowLayout()
    }()
    
    // MARK: - Views
    var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerClass(SingleProductCell.self, forCellWithReuseIdentifier: cellId)
            collectionView.contentInset = UIEdgeInsets(top: (headerHeight + collectionViewMargin), left: collectionViewMargin, bottom: collectionViewMargin, right: collectionViewMargin)
            collectionView.snp_makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
    }
    var headerView: CampaignHeaderView! {
        didSet {
        }
    }
    
    lazy var errorView: ErrorView = ErrorView()
    
    // MARK: - helper method
    
    func setErrorView() {
        self.view.addSubview(errorView)
        errorView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func setDataToModel() {
        Networking.fetchProductsInCurrentCampaign(campaignNiceURL: campaign.niceUrl, productCount: productCount, nextPage: page) { (products, error) in
            if let products = products {
                if products.count < 1 { self.isAnotherPage = false }
                self.products += products
            }
            LoadingOverlay.shared.hideOverlayView()
            if let error = error {
                if self.products.count < 1 {
                    self.setErrorView()
                }
                print(error)
            }
        }
    }
}

extension SingleCampaignViewController: UICollectionViewDataSource {
    // MARK: - CollectionView data source logic
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    // MARK: - Cell logic
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.row == (products.count - 1)) {
            if isAnotherPage {
                page += 1
                setDataToModel()
            }
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! SingleProductCell
        let model = products[indexPath.row]
        
        // MARK: - Vytvoření textu se zvýšeným řádkováním (dle grafického návrhu) pomocí Attributed String
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attrModelName = NSMutableAttributedString(string: model.name)
        attrModelName.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrModelName.length))
        cell.nameLabel.attributedText = attrModelName
        // cell.nameLabel.frame.height = ...
        // cell.nameLabel.numberOfLines = ...
        
        cell.priceLabel.text = BonamiFormatCurrency(model.priceInfo.price, currency: model.priceInfo.currency)
        
        cell.photoLoadIndicator.hidden = false
        cell.photoLoadIndicator.startAnimating()
        cell.productPhotoView.sd_setImageWithURL(NSURL(string: model.images[0].productDetailThumbnailRetina)) { image, error, cacheType, imageURL in
            
            cell.photoLoadIndicator.stopAnimating()
            cell.photoLoadIndicator.hidden = true
            guard (error == nil) else { cell.productPhotoView.image = UIImage(named: "bonami-logo-only")
                
                return
            }
        }
        
        if model.stockInfo.stockType == "soldOut" {
            cell.warningContainer.hidden = false
            cell.warningLabel.text = NSLocalizedString("product_soldOut", comment: "Popisek 'Vyprodáno' v SingleCampaignView a ProductDetailView").uppercaseString
        } else if model.stockInfo.stockType == "reserved" {
            cell.warningContainer.hidden = false
            cell.warningLabel.text = NSLocalizedString("product_reserved", comment: "Popisek 'Rezervováno' v SingleCampaignView a ProductDetailView").uppercaseString
        } else if let warning = model.stockInfo.stockWarning {
            cell.warningContainer.hidden = false
            cell.warningLabel.text = warning.uppercaseString
        } else {
            cell.warningContainer.hidden = true
            cell.warningLabel.text = ""
        }
        
        return cell
    }
}

extension SingleCampaignViewController: UICollectionViewDelegate {
    // MARK: - Navigation logic
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pdvc = ProductDetailViewController()
        pdvc.product = products[indexPath.row]
        
        navigationController?.pushViewController(pdvc, animated: true)
    }
    
    // MARK: - Progressive blurring of header background
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y <= -256.0 {
            headerView.blurContainerView.alpha = 1.0
            scrollView.contentOffset.y = -256.0
        } else if y < -196.0 && y > -256.0 {
            headerView.blurContainerView.alpha = -(y + 196.00) / 60.00
        } else {
            headerView.blurContainerView.alpha = 0.0
        }
    }
}

extension SingleCampaignViewController: UICollectionViewDelegateFlowLayout {
    // FIXME: implement responsiveness to different devices and orientations
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let traits = self.view.traitCollection
        let frame = UIScreen.mainScreen().bounds
        let margin: CGFloat = 17
        
        // iPhone portrait
        if traits.horizontalSizeClass == .Compact && traits.verticalSizeClass == .Regular {
            let width = (frame.width / 2) - margin
            let size = CGSize(width: width, height: (width + 110))
            return size
        }
        // iPhone landscape
        else if traits.horizontalSizeClass == .Compact && traits.verticalSizeClass == .Compact {
            let width = (frame.width / 3) - margin
            let size = CGSize(width: width, height: (width + 110))
            return size
        }
        // iPhone 6 Plus landscape
        else if traits.horizontalSizeClass == .Regular && traits.verticalSizeClass == .Compact {
            let width = (frame.width / 3) - margin
            let size = CGSize(width: width, height: (width + 110))
            return size
        }
        // iPad
        else if traits.horizontalSizeClass == .Regular && traits.verticalSizeClass == .Regular {
            // Portrait
            if frame.width < frame.height {
                let width = (frame.width / 4) - margin
                let size = CGSize(width: width, height: (width + 110))
                return size
            }
            // Landscape
            else {
                let width = (frame.width / 5) - margin
                let size = CGSize(width: width, height: (width + 110))
                return size
            }
        }
        // wtf?
        else {
            print("SingleCampaignViewController collectionView sizeForItemAtIndexPath: \(traits) not recognized! Assuming iPhone sizes...")
            let width = (frame.width / 2) - margin
            return CGSize(width: width, height: (width + 110))
        }
    }
}
