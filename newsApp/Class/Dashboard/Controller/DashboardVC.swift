
//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage
import PagingMenuController
import MXParallaxHeader

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    var controller: [String]
    var viewControllerArray =  NSMutableArray()
    init(controller: [String]) {
        self.controller = controller
        
        for eachController in controller {
            let vc = NEWS_STORY_BOARD.instantiateViewController(withIdentifier: "NewsVC") as! NewsVC
            vc.category = eachController
            viewControllerArray.add(vc)
        }
    }
    
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(array: controller), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return viewControllerArray as! [NewsVC]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        
        var menuArray : [String]
        var array = NSMutableArray()
        
        init(array : [String]) {
            self.menuArray = array
        }
        
        var displayMode: MenuDisplayMode {
            return .standard(widthMode: .flexible, centerItem: true, scrollingMode: .scrollEnabled)
        }
        
        var itemsOptions: [MenuItemViewCustomizable] {
            
            for menu in menuArray {
                array.add(MenuItem(name: menu))
            }
            return array as! [MenuItemViewCustomizable]
            
            
        }
    }
    
    fileprivate struct MenuItem: MenuItemViewCustomizable {
        
        var name: String
        init(name: String) {
            self.name = name
        }
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: self.name))
        }
        
    }
}



class DashboardVC: UIViewController, DashboardAPIDelegate {
    
    var categoryArray = ["Business","Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupViewPagers()
            
    }
    func setupViewPagers() {
        
        let options = PagingMenuOptions(controller: self.categoryArray)
        let pagingMenuController = PagingMenuController(options: options)
        
        //pagingMenuController.view.frame.origin.y += 64
        //pagingMenuController.view.frame.size.height -= 64
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

