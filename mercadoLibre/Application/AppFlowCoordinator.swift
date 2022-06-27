//
//  AppFlowCoordinator.swift
//  mercadoLibre
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appContainer: AppContainer
    
    init(navigationController: UINavigationController,
         appContainer: AppContainer) {
        self.navigationController = navigationController
        self.appContainer = appContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let productsSceneContainer = appContainer.makeProductsSceneContainer()
        let flow = productsSceneContainer.makeProductsListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
