import Foundation

protocol TaskEntity {
    var id: String { get }
    var title: String { get }
    var description: String { get }
    var creationDate: Date { get }
    var isDone: Bool { get }
}

struct TaskEntityImpl: TaskEntity {
    var id: String
    var title: String
    var description: String
    var creationDate: Date
    var isDone: Bool
}
