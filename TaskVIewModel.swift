//TaskViewModel
import SwiftUI
import Firebase
import FirebaseDatabase

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private var dbRef: DatabaseReference!

    // Initialize with the user's ID
    init(userID: String) {
        self.dbRef = Database.database().reference(withPath: "todos/\(userID)")
        fetchTasks() // Fetch tasks when initialized
    }

    // Fetch tasks from Firebase
    func fetchTasks() {
        dbRef.observe(.value) { [weak self] snapshot in
            guard let snapshot = snapshot as? DataSnapshot else {
                print("Failed to cast snapshot to DataSnapshot")
                return
            }

            var tasks: [Task] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    // Print the snapshot value for debugging
                    print("Snapshot value for key \(childSnapshot.key): \(childSnapshot.value ?? "nil")")
                    
                    // Create Task object from childSnapshot
                    if let task = Task(snapshot: childSnapshot) {
                        tasks.append(task)
                    } else {
                        print("Failed to create Task from snapshot with key \(childSnapshot.key)")
                    }
                }
            }
            
            // Update the tasks array on the main thread
            DispatchQueue.main.async {
                self?.tasks = tasks
            }
        }
    }

    // Add a new task to Firebase
    func addTask(title: String) {
        let taskId = dbRef.childByAutoId().key ?? ""  // Handle optional safely
        let task = Task(id: taskId, title: title, completed: false)
        let taskRef = dbRef.child(taskId)
        taskRef.setValue(task.toDictionary())  // Convert Task to dictionary
    }

    // Toggle the completion status of a task
    func toggleTaskCompletion(task: Task) {
        let taskRef = dbRef.child(task.id)
        taskRef.updateChildValues(["completed": !task.completed])
    }

    // Delete a task from Firebase
    func deleteTask(task: Task) {
        let taskRef = dbRef.child(task.id)
        taskRef.removeValue()
    }
}

