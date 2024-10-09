//Task
import FirebaseDatabaseInternal
struct Task: Identifiable, Codable {
    var id: String
    var title: String
    var completed: Bool

    init(id: String, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let title = value["title"] as? String,
              let completed = value["completed"] as? Bool else {
            return nil
        }
        self.id = snapshot.key
        self.title = title
        self.completed = completed
    }

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "completed": completed
        ]
    }
}

