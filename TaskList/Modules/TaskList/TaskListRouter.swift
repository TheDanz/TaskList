protocol TaskListRouter: AnyObject {
    init(_ viewController: TaskListViewImpl)
    
    func openTaskInfo(about task: TaskListEntity)
}

final class TasklistRouterImpl: TaskListRouter {

    weak var viewController: TaskListViewImpl?

    init(_ viewController: TaskListViewImpl) {
        self.viewController = viewController
    }
    
    func openTaskInfo(about task: TaskListEntity) {
        let vc = TaskInfoViewImpl(task: task)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
