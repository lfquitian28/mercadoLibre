//
//  ProductsListItemViewModel.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//
// **Note**: This item view model is to display data and does not contain any domain model to prevent views accessing it

import Foundation

struct ProductsListItemViewModel: Equatable,Identifiable {
    let id: String?
    var title: String?
    var price: Int?
    var thumbnail: String?
}

extension ProductsListItemViewModel {

    init(product: Product) {
        self.id = product.id ?? ""
        self.title = product.title ?? ""
        self.price = product.price ?? 0
        self.thumbnail = product.thumbnail ?? ""
    }
}

final class ListProducts {

    static let shared = ListProducts()
    
    var productsItems: [ProductsListItemViewModel]
    
    init(){
        productsItems = [ProductsListItemViewModel.init(id: "", title: "prueba", price: 0, thumbnail: "")]
    }

}
