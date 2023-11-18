//
//  MyAmazingReminderVersionApp.swift
//  MyAmazingReminderVersion
//
//  Created by Luigi Fiorentino on 14/11/23.
//

import SwiftUI
import SwiftData

@main
struct MyAmazingReminderVersionApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound,.badge]) {result, error in
            if let error=error{
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ReminderView(vm : NotificationDataModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
