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
    var scrapViewController: ScrapViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.dictionary(forKey: "searchFilter") == nil {
            let searchFilter = ["keyword": "Title","sort": "Date","category": "All","language": "eng"]
            UserDefaults.standard.set(searchFilter, forKey: "searchFilter")
        }
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let tabBarConnectedViewcontrollers = tabBarController.customizableViewControllers,
            tabBarConnectedViewcontrollers.count >= 3,
            let navigationController = tabBarConnectedViewcontrollers[2]
                as? UINavigationController,
            let connectedScrapViewController = navigationController.viewControllers.first
                as? ScrapViewController else { return true }
        scrapViewController = connectedScrapViewController
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
