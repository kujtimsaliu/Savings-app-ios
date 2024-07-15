//
//  AppCordinator.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//


import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
//        let tabBarCoordinator = TabBarCoordinator()
    }
    
}


protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
