protocol TaskInfoRouter: AnyObject {
    init(_ viewController: TaskInfoViewImpl)
}

final class TaskInfoRouterImpl: TaskInfoRouter {
    weak var viewController: TaskInfoViewImpl?

    init(_ viewController: TaskInfoViewImpl) {
        self.viewController = viewController
    }
}
