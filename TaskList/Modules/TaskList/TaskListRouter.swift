import UIKit

protocol TaskListRouter: AnyObject {
    init(_ viewController: TaskListViewImpl)
    
    func openEmptyTaskInfo()
    func openTaskInfo(about task: TaskEntity)
    
    func openShareActivityVC(task: TaskEntity)
}

final class TasklistRouterImpl: TaskListRouter {

    weak var viewController: TaskListViewImpl?

    init(_ viewController: TaskListViewImpl) {
        self.viewController = viewController
    }
    
    func openEmptyTaskInfo() {
        let vc = TaskInfoViewImpl()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openTaskInfo(about task: TaskEntity) {
        let vc = TaskInfoViewImpl(task: task)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openShareActivityVC(task: TaskEntity) {
        let activityVC = UIActivityViewController(activityItems: [task.title, task.description], applicationActivities: nil)
        viewController?.present(activityVC, animated: true)
    }
}
