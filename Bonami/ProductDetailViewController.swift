//
//  ProductDetailViewcontroller.swift
//  Bonami
//
//  Created by Jiří Chlum on 10.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit
import SnapKit

private let cellID1 = "ProductDetailCarousel"
private let cellID2 = "ProductDetailName"
private let cellID3 = "ProductDetailProperty"
private let cellID4 = "ProductDetailDescription"

class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var product: Product!
    
    var properties: [ProductProperty] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - preparing View
    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        view.opaque = true
        self.view = view
        
        priceStockInfo.priceInfo = product.priceInfo
        priceStockInfo.stockInfo = product.stockInfo
        
        view.addSubview(priceStockInfo)
        priceStockInfo.snp_makeConstraints { make in
            make.width.equalTo(view)
            make.bottom.equalTo(view)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(priceStockInfo.snp_top)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let carouselCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProductDetailCarousel
        carouselCell.targetImageSize = CGRect(x: 0, y: 0, width: size.height / 3 - 20, height: size.height / 3 - 20)
        
        carouselCell.redoConstraints(size)
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .Plain)
        tableView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        tableView.separatorColor = .clearColor()
        tableView.allowsSelection = false
        
        tableView.registerClass(ProductDetailCarousel.self, forCellReuseIdentifier: cellID1)
        tableView.registerClass(ProductDetailName.self, forCellReuseIdentifier: cellID2)
        tableView.registerClass(ProductDetailProperty.self, forCellReuseIdentifier: cellID3)
        tableView.registerClass(ProductDetailDescription.self, forCellReuseIdentifier: cellID4)
        tableView.scrollEnabled = true
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100
        
        return tableView
    }()
    
    let priceStockInfo: ProductPriceStockView = {
        let psView = ProductPriceStockView(frame: CGRect.zero)
        
        return psView
    }()
}

extension ProductDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.properties.count + 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // n = počet vlastností produktu navýšený o počet buněk před ním (carousel, jméno, značka)
        let n = product.properties.count + 3
        
        switch indexPath.row {
            
            // 1. cell s carouselem
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1, forIndexPath: indexPath) as! ProductDetailCarousel
            cell.images = product.images
            cell.carousel.delegate = self
            return cell
            
            // 2. cell s názvem produktu
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID2, forIndexPath: indexPath) as! ProductDetailName
            cell.nameLabel.text = product.name
            return cell
            
            // 3. cell se značkou (stejný typ jako s vlastnostmi)
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID3, forIndexPath: indexPath) as! ProductDetailProperty
            cell.propertyNameLabel.text = NSLocalizedString("product_brand", comment: "Popisek 'Značka' v třetí obrazovce")
            cell.propertyValueLabel.text = product.brandName
            return cell
            
            // 4. až n-1. cell s vlastností produktu
        case 3 ... n - 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID3, forIndexPath: indexPath) as! ProductDetailProperty
            cell.propertyNameLabel.text = product.properties[indexPath.row - 3].name
            cell.propertyValueLabel.text = product.properties[indexPath.row - 3].value
            return cell
            
            // n. cell s textem
        case n:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID4, forIndexPath: indexPath) as! ProductDetailDescription
            cell.descriptionLabel.text = product.description
            return cell
            
            // ?? ?
            default :
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID3, forIndexPath: indexPath) as! ProductDetailProperty
            
            return cell
        }
    }
}

extension ProductDetailViewController: UITableViewDelegate {
}

extension ProductDetailViewController: MCRotatingCarouselDelegate {
    func rotatingCarousel(carousel: MCRotatingCarousel!, didSelectView view: UIView!, atIndex index: UInt) {
        print("carousel selected photo #\(index)")
        let mpvc = ModalPhotoViewController()
        mpvc.images = product.images[Int(index)]
        self.presentViewController(mpvc, animated: true, completion: nil)
    }
}