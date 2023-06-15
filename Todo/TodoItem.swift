import Foundation

struct TodoItem: Hashable, Identifiable {
    let id = UUID()
    var title: String
    var completed: Bool
}
