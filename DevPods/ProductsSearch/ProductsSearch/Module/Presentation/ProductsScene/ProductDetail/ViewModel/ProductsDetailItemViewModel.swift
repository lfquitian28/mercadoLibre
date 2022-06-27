//
//  ProductsDetailItemViewModel.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 23/06/22.
//

import Foundation


struct ProductsDetailItemViewModel: Equatable,Identifiable {
    let id: String
    let pictures: [ListPictures]
    let price: Int?
    let title: String?
    let attributes: [ListAttributes]
}

extension ProductsDetailItemViewModel {

    init(product: ProductDetail) {
        self.id = product.id
        self.title = product.title ?? ""
        self.price = product.price ?? 0
        self.pictures = product.pictures
        self.attributes = product.attributes
    }
}

final class DetailProducts {

    static let shared = DetailProducts()
    
    var productsDetail: ProductsDetailItemViewModel
    
    init(){
        productsDetail = ProductsDetailItemViewModel.init(id: "", pictures: [], price: 0, title: "", attributes: [] )
    }

}
