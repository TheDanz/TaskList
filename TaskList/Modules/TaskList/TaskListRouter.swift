protocol TaskListRouter: AnyObject {
    init(_ viewviewController: TaskListViewImpl)
}

final class TasklistRouterImpl: TaskListRouter {

    weak var viewController: TaskListViewImpl?

    init(_ viewController: TaskListViewImpl) {
        self.viewController = viewController
    }
}
