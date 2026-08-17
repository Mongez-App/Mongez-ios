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
import Profile
import Common
import CourseDetails
import TeamCourseDetails
import AIStudyRoom
import Swinject
import Organizations
import Payment

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        }
        
        let container = DIContainer.shared.getContainer()
        CourseDetailsAssembly().assemble(container: container)
        TeamCourseDetailsAssembly().assemble(container: container)
        ChatAssembly().assemble(container: container)
        OrganizationsAssembly().assemble(container: container)
        PaymentAssembly().assemble(container: container)
        AppAssembly().assemble(container: container)

        CalendarSyncManager.shared.registerBackgroundTask()

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
    @StateObject private var localization = LocalizationManager.shared

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, localization.language.locale)
                .environment(\.layoutDirection, localization.language.layoutDirection)
                .id(localization.language)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

public class AppAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        
        container.register(CourseDetailsViewModel.self) { (resolver, courseId: String, courseName: String, courseType: String) in
            return CourseDetailsViewModel(
                courseId: courseId,
                courseName: courseName,
                courseType: courseType,
                getMaterialsUseCase: resolver.resolve(GetCourseMaterialsUseCase.self)!,
                getTasksUseCase: resolver.resolve(GetCourseTasksUseCase.self)!,
                uploadMaterialUseCase: resolver.resolve(UploadCourseMaterialUseCase.self)!,
                updateCourseUseCase: resolver.resolve(UpdateCourseUseCase.self)!,
                deleteCourseUseCase: resolver.resolve(DeleteCourseUseCase.self)!,
                deleteCourseMaterialUseCase: resolver.resolve(DeleteCourseMaterialUseCase.self)!
            )
        }
        
        container.register(TeamCourseDetailsViewModel.self) { (resolver, courseId: String, organizationId: String, courseName: String, courseType: String) in
            return TeamCourseDetailsViewModel(
                courseId: courseId,
                organizationId: organizationId,
                courseName: courseName,
                courseType: courseType,
                getMaterialsUseCase: resolver.resolve(GetTeamCourseMaterialsUseCase.self)!,
                getTasksUseCase: resolver.resolve(GetTeamCourseTasksUseCase.self)!
            )
        }
        
    }
}
