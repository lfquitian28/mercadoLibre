//
//  ProductDetailResponseStorage.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation

protocol ProductDetailResponseStorage {
    func getResponse(for request: ProductDetailRequestDTO, completion: @escaping (Result<ProductsDetailBodyResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: ProductsDetailBodyResponseDTO, for requestDto: ProductDetailRequestDTO)
}
