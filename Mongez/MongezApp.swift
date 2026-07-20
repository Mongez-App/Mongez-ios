//
//  MongezApp.swift
//  Mongez
//
//  Created by mohamed sharaf on 15/07/2026.
//
import SwiftUI
import FirebaseCore
import GoogleSignIn
import Authntication
 
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
 
        FirebaseApp.configure()
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        }
 
        return true
    }
 
    func application(_ app: UIApplication,
                      open url: URL,
                      options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
 
@main
struct MongezApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 
    let persistenceController = PersistenceController.shared
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
