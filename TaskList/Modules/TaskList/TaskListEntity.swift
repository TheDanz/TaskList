import Foundation

protocol TaskListEntity {
    var title: String { get }
    var description: String { get }
    var creationDate: Date { get }
    var isDone: Bool { get }
}

struct TaskListEntityImpl: TaskListEntity {
    var title: String
    var description: String
    var creationDate: Date
    var isDone: Bool
}
