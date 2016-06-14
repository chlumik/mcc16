//
//  CampaignModel.swift
//  Bonami
//
//  Created by Jiří Chlum on 07.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import Curry
import Argo

struct Campaign {
    let niceUrl: String
    let name: String
    let onStockCampaign: Bool
    let endAt: String?
    let perex: String
    let description: String
    let authorTitle: String
    let authorDescription: String
    let productCount: Int
    let url: String
    let images: CampaignImage
}

extension Campaign: Decodable {
    static func decode(json: JSON) -> Decoded<Campaign> {
        let f = curry(Campaign.init)
        return f
        <^> json <| "niceUrl"
        <*> json <| "name"
        <*> json <| "onStockCampaign"
        <*> json <|? "endAt"
        <*> json <| "perex"
        <*> json <| "description"
        <*> json <| "authorTitle"
        <*> json <| "authorDescription"
        <*> json <| "productCount"
        <*> json <| "url"
        <*> json <| "images"
    }
}

struct CampaignImage {
    let homepageLowres: String?
    let homepageMain: String?
    let homepageThumbnail: String?
    let homepageRetina: String?
    let author: String?
}

extension CampaignImage: Decodable {
    static func decode(json: JSON) -> Decoded<CampaignImage> {
        return curry(CampaignImage.init)
        <^> json <|? "homepage-lowres"
        <*> json <|? "homepage-main"
        <*> json <|? "homepage-thumbnail"
        <*> json <|? "homepage-retina"
        <*> json <|? "author"
    }
}