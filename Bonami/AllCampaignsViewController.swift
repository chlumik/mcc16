//
//  AllCampaignsViewController.swift
//  Bonami
//
//  Created by Jiří Chlum on 10.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

private let cellId = "AllCampaignsCellId"
private let margin: CGFloat = 12
class AllCampaginsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Model
    
    var campaigns: [Campaign] = [] {
        didSet {
            collectionView.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        LoadingOverlay.shared.showOverlay(view)
        refreshControl.addTarget(self, action: #selector(spin), forControlEvents: .ValueChanged)
        setupRefreshControl()
        
        errorView.onRetryButtonClick = { [weak self] Void in
            self?.errorView.removeFromSuperview()
            self!.refreshData()
            LoadingOverlay.shared.showOverlay(self?.view)
        }
        
        print("Disk cache size: \(SDImageCache.sharedImageCache().getDiskCount())")
    }
    
    // MARK: - preparing View
    
    override func loadView() {
        super.loadView()
        self.title = NSLocalizedString("allcampaignsview_title", comment: "Titulek první obrazovky")
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        view.opaque = true
        self.view = view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        self.collectionView = collectionView
        self.collectionView.addSubview(refreshControl)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Layout
    let layout: UICollectionViewFlowLayout = {
        return UICollectionViewFlowLayout()
    }()
    
    // MARK: - Views
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var errorView: ErrorView = ErrorView()
    
    weak var refreshBackgoundView: UIView!
    
    weak var refreshImageView: RefreshView!
    
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .clearColor()
            collectionView.alwaysBounceVertical = true
            collectionView.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: margin, right: margin)
            collectionView.registerClass(AllCampaignsCell.self, forCellWithReuseIdentifier: cellId)
            collectionView.snp_makeConstraints { (make) in
                make.leading.trailing.bottom.equalTo(self.view)
                make.top.equalTo(self.view).offset(margin)
            }
        }
    }
    
    // MARK: - refresh
    
    func setupRefreshControl() {
        let refreshBackgoundView = UIView(frame: self.refreshControl.bounds)
        refreshControl.addSubview(refreshBackgoundView)
        refreshControl.tintColor = .clearColor()
        refreshBackgoundView.backgroundColor = .whiteColor()
        self.refreshBackgoundView = refreshBackgoundView
        
        let refreshImage = RefreshView(frame: CGRect(origin: self.refreshBackgoundView.frame.origin, size: CGSize(width: 50, height: 50)))
        
        self.refreshBackgoundView.addSubview(refreshImage)
        self.refreshImageView = refreshImage
    }
    
    func refreshData() {
        Networking.fetchAllCampaigns { (campaigns, error) in
            if let campaigns = campaigns {
                self.campaigns = campaigns.reverse()
            }
            self.refreshControl.endRefreshing()
            LoadingOverlay.shared.hideOverlayView()
            if let error = error {
                if self.campaigns.count < 1 {
                    self.setErrorView()
                    print(error)
                }
            }
        }
    }
    
    func setErrorView() {
        self.view.addSubview(errorView)
        errorView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func spin() {
        refreshData()
        animeteWhileRefresh()
    }
    
    func animeteWhileRefresh() {
        UIView.animateWithDuration(0.2, delay: Double(0.0), options: .CurveLinear, animations: {
            self.refreshImageView.transform = CGAffineTransformRotate(self.refreshImageView.transform, CGFloat(M_PI))
        }) { (finished) in
            if self.refreshControl.refreshing {
                self.animeteWhileRefresh()
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pullDistance = max(0.0, -self.refreshControl.frame.origin.y)
        var refreshBounds = self.refreshControl.bounds
        let imageSize = self.refreshImageView.frame.size
        refreshBounds.size.height = pullDistance
        refreshBounds.size.width = collectionView.frame.width - 2 * margin
        self.refreshBackgoundView.frame = refreshBounds
        let midX = (self.collectionView.frame.size.width / 2) - margin - (imageSize.width / 2)
        var imageY = refreshBounds.size.height / 2 - imageSize.height / 2
        
        if refreshBounds.size.height < imageSize.height {
            imageY = refreshBounds.size.height - imageSize.height
        }
        self.refreshImageView.frame.origin = CGPoint(x: midX, y: imageY)
    }
}

extension AllCampaginsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! AllCampaignsCell
        cell.campaign = campaigns[indexPath.row]
        cell.layer.cornerRadius = 5
        return cell
    }
}
extension AllCampaginsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = campaigns[indexPath.row]
        let scvc = SingleCampaignViewController()
        scvc.campaign = model
        navigationController?.pushViewController(scvc, animated: true)
    }
}

extension AllCampaginsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let traits = self.view.traitCollection
        let frame = UIScreen.mainScreen().bounds
        let margin: CGFloat = 24
        
        // iPhone portrait
        if traits.horizontalSizeClass == .Compact && traits.verticalSizeClass == .Regular {
            let width = (frame.width - margin)
            let size = CGSize(width: width, height: 250)
            return size
        }
        // iPhone landscape
        else if traits.horizontalSizeClass == .Compact && traits.verticalSizeClass == .Compact {
            let width = (frame.width / 2) - margin
            let size = CGSize(width: width, height: frame.height)
            return size
        }
        // iPhone 6 Plus landscape
        else if traits.horizontalSizeClass == .Regular && traits.verticalSizeClass == .Compact {
            let width = (frame.width / 2) - margin
            let size = CGSize(width: width, height: frame.height)
            return size
        }
        // iPad
        else if traits.horizontalSizeClass == .Regular && traits.verticalSizeClass == .Regular {
            // Portrait
            if frame.width < frame.height {
                let width = (frame.width / 3) - margin
                let size = CGSize(width: width, height: (width + 70))
                return size
            }
            // Landscape
            else {
                let width = (frame.width / 4) - margin
                let size = CGSize(width: width, height: (width))
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
