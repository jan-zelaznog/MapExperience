//
//  CustomTabBarController.swift
//  MapExperience
//
//  Created by Ángel González on 28/05/22.
//


import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let purple = UIColor(red: 82.0 / 255.0, green: 25.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
        let orange = UIColor.orange.withAlphaComponent(0.5)
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(orange, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        tabBar.tintColor = .white
        tabBar.barTintColor = .red
        tabBar.backgroundColor = .red
        tabBar.isOpaque = true
        tabBar.isTranslucent = false
    }
}

extension UIImage {
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
