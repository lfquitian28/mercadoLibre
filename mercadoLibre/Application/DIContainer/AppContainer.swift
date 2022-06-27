//
//  AppContainer.swift
//  mercadoLibre
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation
import Networking
import ProductsSearch

final class AppContainer {
    lazy var serviceConfiguration = ServiceConfiguration()
    // MARK: - Network
    lazy var apiDataTransferSer: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: serviceConfiguration.baseURL)!)
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    
    // MARK: - Pokemon of scenes
    func makeProductsSceneContainer()-> ProductsSceneContainer {
        let dependencies = Dependencies(apiDataTransferService: apiDataTransferSer)
        return ProductsSceneContainer(dependencies: dependencies)
    }
}
