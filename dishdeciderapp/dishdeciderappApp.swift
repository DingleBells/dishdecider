//
//  dishdeciderappApp.swift
//  dishdeciderapp
//
//  Created by Kanghee Cho on 4/11/25.
//

import SwiftUI

@main
struct dishdeciderappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
