//
//  AppDelegate.swift
//  mercadoLibre
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import UIKit
import ProductsSearch

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
    }

}

