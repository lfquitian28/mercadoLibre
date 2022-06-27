//
//  ProductsResponseStorage.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

protocol ProductsResponseStorage {
    func getResponse(for request: ProductsRequestDTO, completion: @escaping (Result<ProductsResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: ProductsResponseDTO, for requestDto: ProductsRequestDTO)
}
