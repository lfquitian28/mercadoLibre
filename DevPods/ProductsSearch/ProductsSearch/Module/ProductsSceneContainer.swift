//
//  ProductsSceneContainer.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import UIKit
import SwiftUI
import Networking

public struct Dependencies {
    let apiDataTransferService: DataTransferService
    
    public init(apiDataTransferService: DataTransferService){
        self.apiDataTransferService = apiDataTransferService
    }
}

public final class ProductsSceneContainer {
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var productsQueriesStorage: ProductsQueriesStorage = CoreDataProductsQueriesStorage(maxStorageLimit: 10)
    lazy var productsResponseCache: ProductsResponseStorage = CoreDataProductsResponseStorage()
    lazy var productDetailQueriesStorage: ProductDetailQueriesStorage = CoreDataProductDetailQueriesStorage(maxStorageLimit: 10)
    lazy var productDetailResponseCache: ProductDetailResponseStorage = CoreDataProductDetailResponseStorage()

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    // MARK: - Use Cases
    func makeListProductsUseCase() -> ListProductsUseCase {
        return DefaultSearchProductsUseCase(productsRepository: makeProductsRepository(),
                                          productsQueriesRepository: makeProductsQueriesRepository())
    }
    func makeFetchRecentProductQueriesUseCase(requestValue: FetchRecentProductQueriesUseCase.RequestValue,
                                            completion: @escaping (FetchRecentProductQueriesUseCase.ResultValue) -> Void) -> UseCase {
        return FetchRecentProductQueriesUseCase(requestValue: requestValue,
                                              completion: completion,
                                              productsQueriesRepository: makeProductsQueriesRepository()
        )
    }
    
    func makeListProductDetailUseCase() -> ProductDetailUseCase {
        
        return DefaultProductDetailUseCase(productDetailRepository: makeProductDetailRepository(), productDetailQueriesRepository: makeProductsQueriesRepository())
        
    }
    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository(dataTransferService: dependencies.apiDataTransferService, cache: productsResponseCache)
    }
    
    func makeProductsQueriesRepository() -> ProductsQueriesRepository {
        return DefaultProductsQueriesRepository(dataTransferService: dependencies.apiDataTransferService,
                                              productsQueriesPersistentStorage: productsQueriesStorage)
    }
    
    func makeProductDetailRepository() -> ProductDetailRepository {
        return DefaultProductsDetailRepository(dataTransferService: dependencies.apiDataTransferService, cache: productDetailResponseCache)
    }
    
    func makeProductsQueriesRepository() -> ProductDetailQueriesRepository {
        return DefaultProductDetailQueriesRepository(dataTransferService: dependencies.apiDataTransferService, productDetailQueriesPersistentStorage: productDetailQueriesStorage)
    }

    // MARK: - Products List
    func makeProductsListViewController(actions: ProductsListViewModelActions) -> ProductsListViewController {
        return ProductsListViewController.create(with: makeProductsListViewModel(actions: actions))
    }
 
    func makeProductsListViewModel(actions: ProductsListViewModelActions) -> ProductsListViewModel {
        let viewModel = DefaultProductsListViewModel(searchProductsUseCase: makeListProductsUseCase(),
                                          actions: actions)
        return viewModel
    }

    // MARK: - Flow Coordinators
    public func makeProductsListFlowCoordinator(navigationController: UINavigationController) -> ProductsListFlowCoordinator {
        return ProductsListFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    // MARK: - Product Detail
    func makeProductDetailViewController(product: Product) -> ProductDetailViewController {
        return ProductDetailViewController.create(with: makeProductDetailViewModel(product: product))
    }
    
    func makeProductDetailViewModel(product: Product) -> ProductDetailViewModel {
        return DefaultProductDetailViewModel(searchProductDetailUseCase: makeListProductDetailUseCase(), product: product)
    }
    
    
    
}
//
extension ProductsSceneContainer: ProductsListFlowCoordinatorDependencies {}
