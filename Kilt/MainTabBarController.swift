//
//  MainTabBarController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            UINavigationController(rootViewController: CardsViewController()),
            UINavigationController(rootViewController: MessagesViewController()),
            UINavigationController(rootViewController: DiscountsViewController()),
            UINavigationController(rootViewController: ProfileViewController())
        ]
        
        tabBar.tintColor = .appColor()
        setUpTabBarItem(tabBar.items?[0], title: "Карточки",
                        image: Icon.cardsIcon, selectedImage: Icon.cardsSelectedIcon)
        setUpTabBarItem(tabBar.items?[1], title: "Сообщения",
                        image: Icon.messagesIcon, selectedImage: Icon.messagesSelectedIcon)
        setUpTabBarItem(tabBar.items?[2], title: "Бонусы",
                        image: Icon.discountsIcon, selectedImage: Icon.discountsSelectedIcon)
        setUpTabBarItem(tabBar.items?[3], title: "Профиль",
                        image: Icon.profileIcon, selectedImage: Icon.profileSelectedIcon)
    }
    
    // MARK: Set Up
    
    private func setUpTabBarItem(tabBarItem: UITabBarItem?, title: String?, image: UIImage?, selectedImage: UIImage?) {
        tabBarItem?.title = title
        tabBarItem?.image = image
        tabBarItem?.selectedImage = selectedImage
    }
}
