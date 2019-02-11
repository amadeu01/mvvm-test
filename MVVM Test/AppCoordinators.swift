//
//  AppCoordinators.swift
//  MVVM Test
//
//  Created by Amadeu Cavalcante Filho on 11/02/19.
//  Copyright © 2019 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit

final public class AppCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    
    public func start() {
        let saveStuffVM = SaveViewModel()
        let saveVC = SaveStuffViewController(viewModel: saveStuffVM)
        saveVC.coordinator = self
        navigationController.pushViewController(saveVC, animated: true)
    }
}

extension AppCoordinator {
    
    public func stuffSaved() {
        navigationController.popViewController(animated: true)
        let saveStuffVM = SaveViewModel()
        let saveVC = SaveStuffViewController(viewModel: saveStuffVM)
        saveVC.coordinator = self
        navigationController.pushViewController(saveVC, animated: true)
    }
}
