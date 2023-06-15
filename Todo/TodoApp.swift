import SwiftUI

@main
struct TodoApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            TodoView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
