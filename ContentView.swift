//ContentView
import SwiftUI
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var taskViewModel: TaskViewModel
    @State private var newTaskName = ""

    init(authViewModel: AuthViewModel) {
        _taskViewModel = StateObject(wrappedValue: TaskViewModel(userID: authViewModel.user?.uid ?? ""))
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(taskViewModel.tasks) { task in
                        HStack {
                            Text(task.title)
                                
                            Spacer()
                            if task.completed {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .onTapGesture {
                            taskViewModel.toggleTaskCompletion(task: task)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let task = taskViewModel.tasks[index]
                            taskViewModel.deleteTask(task: task)
                        }
                    }
                }
                .navigationTitle("To-Do List")
                .font(.custom("Menlo", size: 18))

                HStack {
                    TextField("New Task", text: $newTaskName)
                        .font(.custom("Menlo", size: 14))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        guard !newTaskName.isEmpty else { return }
                        taskViewModel.addTask(title: newTaskName)
                        newTaskName = ""
                    }) {
                        Text("Add")
                            .font(.custom("Menlo", size: 14))
                    }
                }
                .padding()
                
                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Sign Out")
                        .font(.custom("Menlo", size: 14))
                }
                .padding()
            }
        }
    }
}

