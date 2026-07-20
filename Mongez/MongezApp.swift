//
//  MongezApp.swift
//  Mongez
//
//  Created by mohamed sharaf on 15/07/2026.
//
import SwiftUI
import OnBoarding


@main
struct MongezApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OnBoardingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
