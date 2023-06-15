import SwiftUI

struct TodoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var completed: Bool = false
    
    @FetchRequest(entity: TodoItem.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)]) private var todoItems: FetchedResults<TodoItem>
    
    private func saveTodoItem() {
        
        do {
            let todoItem = TodoItem(context: viewContext)
            todoItem.title = title
            todoItem.completed = completed
            todoItem.id = UUID()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateTodoItem(_ item: TodoItem) {
        item.completed = !item.completed
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTodoItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = todoItems[index]
            viewContext.delete(item)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            Text("To Do List").font(.largeTitle)
            
            HStack {
                TextField("New thing to do", text: $title)
                Button {
                    saveTodoItem()
                } label: {
                    Text("Add")
                }
                .disabled(title.isEmpty)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
            .padding(.init(top: 0, leading: 20, bottom: 10, trailing:20))
            List {
                ForEach(todoItems, id: \.self) { item in
                    HStack {
                        Image(systemName: item.completed ? "checkmark.square" : "square" )
                            .resizable()
                            .frame(width: 22, height: 22)
                            .onTapGesture {
                                updateTodoItem(item)
                            }
                        Text(item.title ?? "")
                            .strikethrough(item.completed)
                    }
                }
                .onDelete(perform: deleteTodoItem)
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        TodoView().environment(\.managedObjectContext, persistedContainer.viewContext)
    }
}
