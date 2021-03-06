//
//  SceneDelegate.swift
//  AvitoTest
//
//  Created by Sultan on 03.01.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootVC = UINavigationController(rootViewController: AdsViewController())
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    
//    func sceneWillEnterForeground(_ scene: UIScene) {
//        NetworkMonitor.shared.startMonitoring()
//
//    }
//    
//    func sceneDidBecomeActive(_ scene: UIScene) {
//        NetworkMonitor.shared.startMonitoring()
//    }
//
//    func sceneDidEnterBackground(_ scene: UIScene) {
//        NetworkMonitor.shared.stopMonitoring()
//    }

}

