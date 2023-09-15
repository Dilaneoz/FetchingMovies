//
//  TabBarViewController.swift
//  FilmApp
//
//  Created by Opendart Yazılım ve Bilişim Hizmetleri on 25.02.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    // main de view controller lara çizgi çekerken show yerine view controllers seçilir
    
    var tabItem1 = UITabBarItem()
    var tabItem2 = UITabBarItem()
    var tabItem3 = UITabBarItem()
    var tabItem4 = UITabBarItem()
    
    let homeIMG = UIImage(named: "home")
    let searchIMG = UIImage(named: "search")
    let categoryIMG = UIImage(named: "category")
    let favoriIMG = UIImage(named: "heart")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabItem1 = self.tabBar.items![0] // tabbar ın altındaki elemanlar array mantığıyla çalışır
        tabItem2 = self.tabBar.items![1] // 1. elemanı al tabItem2 ile eşleştir
        tabItem3 = self.tabBar.items![2]
        tabItem4 = self.tabBar.items![3]
        
        tabItem1.title = "Home"
        tabItem2.title = "Search"
        tabItem3.title = "Categories"
        tabItem4.title = "Favorites"
        
        tabItem1.image = homeIMG
        tabItem2.image = searchIMG
        tabItem3.image = categoryIMG
        tabItem4.image = favoriIMG
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
