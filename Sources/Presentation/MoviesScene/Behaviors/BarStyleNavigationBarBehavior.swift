//
//  BarStyleNavigationBarBehavior.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 26/05/2020.
//

import UIKit

struct BarStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationController?.navigationBar.barStyle = .default
    }
}
