//
//  AppDelegate.swift
//  tree
//
//  Created by hyerikim on 22/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        guard let tabBarController = window?.rootViewController as? ScrapTabBarController else {
//            return false
//        }
//        guard let scrapViewContoller = tabBarController.flowToViewController(itemIdx: 0) as? ScrapViewController else {
//            return false
//        }
//        scrapViewContoller.managedContext = persistentContainer.viewContext
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TreeData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

private extension UITabBarController {
    
    /**
     *A description field*
     - important:
     if your destination UIViewController is wrapped by structure like
     UITabBarController -> UINavigationController -> destination,
     this function will help to find destination easily
     
     - returns: Destination UIViewController
     
     *Another description field*
     - version: 1.0
     
     */
    func flowToViewController(itemIdx: Int) -> UIViewController {
        guard let navigationController = self.customizableViewControllers?[itemIdx] as? UINavigationController else {
            return UIViewController()
        }
        guard let targetViewController = navigationController.viewControllers[0] as? UIViewController else {
            return UIViewController()
        }
        return targetViewController
    }
}
