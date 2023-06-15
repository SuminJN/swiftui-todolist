import SwiftUI

struct TodoView: View {
    @State var todoItems: [TodoItem] = [
        TodoItem(title: "Go shopping", completed: false),
        TodoItem(title: "Take photos", completed: false),
        TodoItem(title: "Do the laundry", completed: true)
    ]
    
    @State var newTodoItemTitle = ""
    
    var body: some View {
        VStack {
            Text("To Do List").font(.largeTitle)
            HStack {
                TextField("New thing to do", text: $newTodoItemTitle)
                Button {
                    let newItem = TodoItem(title: newTodoItemTitle, completed: false)
                    todoItems.insert(newItem, at: 0)
                    newTodoItemTitle = ""
                } label: {
                    Text("Add")
                }
                .disabled(newTodoItemTitle.isEmpty)
            }
            .padding()
            .border(Color.black)
            .padding(.init(top: 0, leading: 20, bottom: 10, trailing:20))
            
            List(todoItems.indices, id: \.self) { index in
                HStack {
                    Toggle("", isOn: $todoItems[index].completed)
                        .toggleStyle(CheckBoxToggleStyle())
                    Text(todoItems[index].title)
                        .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                }
            }
        }
    }
}

struct CheckBoxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
