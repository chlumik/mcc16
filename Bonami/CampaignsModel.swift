//
//  Campaign.swift
//  Bonami
//
//  Created by Jiří Chlum on 07.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import Curry
import Argo

struct Campaigns {
    let campaign: [Campaign]
    // let link: Links
}

extension Campaigns: Decodable {
    static func decode(json: JSON) -> Decoded<Campaigns> {
        return curry(Campaigns.init)
        <^> json <|| "campaigns"
        // <*> json <| "links"
    }
}

//struct Links {
//    let prev: String
//    let next: String
//}

//extension Links: Decodable {
//    static func decode(json: JSON) -> Decoded<Links> {
//        return curry(Links.init)
//        <^> json <| "prev"
//        <*> json <| "next"
//    }
//}
