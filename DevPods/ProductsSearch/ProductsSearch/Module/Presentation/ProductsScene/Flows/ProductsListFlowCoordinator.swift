//
//  ProductsListFlowCoordinator.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import UIKit

protocol ProductsListFlowCoordinatorDependencies  {
    func makeProductsListViewController(actions: ProductsListViewModelActions) -> ProductsListViewController
    func makeProductDetailViewController(product: Product) -> ProductDetailViewController
}

public final class ProductsListFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ProductsListFlowCoordinatorDependencies

    private weak var productsListVC: ProductsListViewController?
    private weak var productDetailVC: ProductDetailViewController?


    init(navigationController: UINavigationController,
         dependencies: ProductsListFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = ProductsListViewModelActions(showProductDetails: showProductDetails)
        let vc = dependencies.makeProductsListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: true)
        productsListVC = vc
    }

    private func showProductDetails(product: Product) {
        let vc = dependencies.makeProductDetailViewController(product: product)
        navigationController?.pushViewController(vc, animated: true)
        productDetailVC = vc
    }

}
