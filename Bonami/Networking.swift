//
//  Connections.swift
//  testovaniViewBonami
//
//  Created by Jiří Chlum on 29.04.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import Alamofire
import Argo

class Networking {
    
    static let deviceLanguage: String = {
        let language = NSLocale.preferredLanguages()[0]
        switch language[1] {
        case "cs":
            return "cz"
        case "sk":
            return "sk"
        case "pl":
            return "pl"
        default:
            return "cz"
        }
    }()
    
    private enum EndPointURL {
        case AllCampaigns
        case Campaign(niceURL: String, productCount: Int, page: Int)
        case Product(niceURL: String)
        
        var path: String {
            let baseURL: String = "https://www.bonami.cz/mcc16/"
            
            switch self {
            case .AllCampaigns: return baseURL + "campaigns"
            case let .Campaign(niceURL, productCount, page): return "\(baseURL)campaigns/\(niceURL)/products?limit=\(productCount)&page=\(page)"
            case let .Product(niceURL): return baseURL + "products/" + niceURL
            }
        }
    }
    
    private static var headers = ["Accept-Language": deviceLanguage]
    
    class func fetchAllCampaigns(completion: ([Campaign]?, DataError?) -> Void) {
        
        let url = EndPointURL.AllCampaigns.path
        Alamofire.request(.GET, url, headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    completion(nil, .ResponseError)
                    return
                }
                guard let value = response.result.value,
                    models: Decoded<[Campaign]> = decode(value),
                    data: [Campaign] = models.value else {
                        completion(nil, .ParseError)
                        return
                }
                
                completion(data, nil)
        }
    }
    
    class func fetchProductsInCurrentCampaign(campaignNiceURL niceURL: String, productCount count: Int, nextPage page: Int, completion: ([Product]?, DataError?) -> Void) {
        let url = EndPointURL.Campaign(niceURL: niceURL, productCount: count, page: page).path
        Alamofire.request(.GET, url, headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    completion(nil, .ResponseError)
                    return
                }
                
                guard let value = response.result.value,
                    models: Decoded<[Product]> = decode(value),
                    data: [Product] = models.value else {
                        completion(nil, .ParseError)
                        return
                }
                
                completion(data, nil)
        }
    }
    
    class func fetchCurrentProduct(productNiceURL niceURL: String, completion: (Product?) -> Void) {
        let url = EndPointURL.Product(niceURL: niceURL).path
        Alamofire.request(.GET, url, headers: headers)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value,
                    models: Decoded<Product> = decode(value),
                    data: Product = models.value else {
                        completion(nil)
                        return
                }
                completion(data)
        }
    }
}
