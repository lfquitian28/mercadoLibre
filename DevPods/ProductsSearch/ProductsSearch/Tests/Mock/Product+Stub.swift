//
//  Product+Stub.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 26/06/22.
//

import Foundation
@testable import ProductsSearch

extension Product {
    
    static func stub(id: String = "id1",
                title: String = "title1" ,
                price: Int = 0,
                thumbnail: String = "/1") -> Self {
        
        Product(id: id, title: title, price: price, thumbnail: thumbnail)
    }
}
