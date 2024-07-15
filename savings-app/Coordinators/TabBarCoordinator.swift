//
//  TabBarCoordinator.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class TabBarCoordinator: Coordinator {
    let window: UIWindow
    let childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
    }
}
