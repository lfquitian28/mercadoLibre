//
//  Product.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

struct Product: Equatable {
    let id: String?
    let title: String?
    let price: Int?
    let thumbnail: String?
}

struct ProductsPage: Equatable {
    let products: [Product]
    let page: Int
}



struct ListPictures: Equatable {
    let id: String?
    let url: String?
}

struct ListAttributes: Equatable {
    let id: String?
    let name: String?
    let value_name: String?
}



struct ProductDetail: Equatable {
    let id: String
    let pictures: [ListPictures]
    let price: Int?
    let title: String?
    let attributes: [ListAttributes]
    
}

struct ProductDetailBody: Equatable {
    let body: ProductDetail
    
}
