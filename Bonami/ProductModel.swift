//
//  ProductModel.swift
//  Bonami
//
//  Created by Jiří Chlum on 07.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import Curry
import Argo

struct Product {
    let niceURL: String
    let name: String
    let description: String
    let brandName: String
    let priceInfo: ProductPriceInfo
    let stockInfo: ProductStockInfo
    let campaignEndAt: String
    let url: String
    let properties: [ProductProperty]
    let images: [ProductImage]
}

extension Product: Decodable {
    static func decode(json: JSON) -> Decoded<Product> {
        return curry(Product.init)
        <^> json <| "niceUrl"
        <*> json <| "name"
        <*> json <| "description"
        <*> json <| "brandName"
        <*> json <| "priceInfo"
        <*> json <| "stockInfo"
        <*> json <| "campaignEndAt"
        <*> json <| "url"
        <*> json <|| "properties"
        <*> json <|| "images"
    }
}

struct ProductProperty {
    let name: String
    let value: String?
}

extension ProductProperty: Decodable {
    static func decode(json: JSON) -> Decoded<ProductProperty> {
        return curry(ProductProperty.init)
        <^> json <| "name"
        <*> json <|? "value"
    }
}

struct ProductPriceInfo {
    let price: String
    let currency: String
    let retailPrice: String?
    let retailPriceCurrency: String?
    let shippingPrice: String?
    let shippingPriceCurrency: String?
}

extension ProductPriceInfo: Decodable {
    static func decode(json: JSON) -> Decoded<ProductPriceInfo> {
        return curry(ProductPriceInfo.init)
        <^> json <| "price"
        <*> json <| "currency"
        <*> json <|? "retailPrice"
        <*> json <|? "retailPriceCurrency"
        <*> json <|? "shippingPrice"
        <*> json <|? "shippingPriceCurrency"
    }
}

struct ProductStockInfo {
    let stockType: String
    let stockInfoText: String?
    let stockWarning: String?
}

extension ProductStockInfo: Decodable {
    static func decode(json: JSON) -> Decoded<ProductStockInfo> {
        return curry(ProductStockInfo.init)
        <^> json <| "stockType"
        <*> json <|? "stockInfoText"
        <*> json <|? "stockWarningText"
    }
}

struct ProductImage {
    let productDetailThumbnail: String
    let productDetailThumbnailRetina: String
    let productDetailThumbnailFull: String
}

extension ProductImage: Decodable {
    static func decode(json: JSON) -> Decoded<ProductImage> {
        return curry(ProductImage.init)
        <^> json <| "productDetail-thumbnail"
        <*> json <| "productDetail-thumbnail-retina"
        <*> json <| "productDetail-thumbnail-full"
    }
}
