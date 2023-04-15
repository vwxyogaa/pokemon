//
//  TabBarViewController.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makeTabBar() -> TabBarViewController {
        self.viewControllers = [
            makeNavigation(viewController: createHomeTab()),
            makeNavigation(viewController: createMyBagTab())
        ]
        return self
    }
    
    private func makeNavigation(viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = false
        return navigation
    }
    
    private func createHomeTab() -> UIViewController {
        let homeController = HomeViewController()
        homeController.tabBarItem.title = "Home"
        homeController.tabBarItem.image = UIImage(systemName: "house")
        homeController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        let homeViewModel = HomeViewModel(homeUseCase: Injection().provideHomeUseCase())
        homeController.viewModel = homeViewModel
        return homeController
    }
    
    private func createMyBagTab() -> UIViewController {
        let myBagController = MyBagViewController()
        myBagController.tabBarItem.title = "My Bag"
        myBagController.tabBarItem.image = UIImage(systemName: "bookmark")
        myBagController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        let myBagViewModel = MyBagViewModel(myBagUseCase: Injection().provideMyBagUseCase())
        myBagController.viewModel = myBagViewModel
        return myBagController
    }
}
