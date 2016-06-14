//
//  ModalPhotoViewController.swift
//  Bonami
//
//  Created by Jan Nejtek on 26/05/16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ModalPhotoViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var images: ProductImage!
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        downloadImage()
    }
    
    // MARK: - preparing View
    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .whiteColor()
        view.opaque = true
        self.view = view
        
        self.view.addSubview(scrollView)
        self.view.addSubview(backButton)
        self.view.addSubview(photoLoadIndicator)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        backButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.leading.equalTo(self.view).offset(10)
        }
        
        backButton.addTarget(self, action: #selector(dismiss), forControlEvents: .TouchUpInside)
        
        photoLoadIndicator.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.backgroundColor = .clearColor()
        return scrollview
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        let title = NSLocalizedString("backButton", comment: "Tlačítko pro návrat z modalView")
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(.blueColor(), forState: .Normal)
        return button
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let photoLoadIndicator: UIActivityIndicatorView = {
        let indicatorview = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicatorview.color = .grayColor()
        
        return indicatorview
    }()
    
    func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func downloadImage() {
        photoLoadIndicator.hidden = false
        photoLoadIndicator.startAnimating()
        imageView.sd_setImageWithURL(NSURL(string: images.productDetailThumbnailFull)) { (image, error, cashe, nsurl) in
            guard error == nil else { return }
            self.setup(image)
        }
    }
    
    func setup(image: UIImage) {
        photoLoadIndicator.hidden = true
        photoLoadIndicator.stopAnimating()
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        
        let minScale = min(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = minScale
        
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsize.width {
            contentsFrame.origin.x = (boundsize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsize.height {
            contentsFrame.origin.y = (boundsize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        
        let pointInView = recognizer.locationInView(imageView)
        
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h)
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
}