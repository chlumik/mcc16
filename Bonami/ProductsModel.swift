//
//  ProductsModel.swift
//  Bonami
//
//  Created by Jiří Chlum on 07.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import Curry
import Argo

struct Products {
    let product: [Product]
    //let links: Links
}

extension Products: Decodable {
    static func decode(json: JSON) -> Decoded<Products> {
        return curry(Products.init)
        <^> json <|| "products"
        //<*> json <| "links"
    }
}