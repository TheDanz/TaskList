protocol TaskListAssambly {
    func configure(view: TaskListViewImpl)
}

final class TaskListAssamblyImpl: TaskListAssambly {
    func configure(view: TaskListViewImpl) {
        let presenter = TaskListPresenterImpl(view)
        let interactor = TaskListInteractorImpl()
        let router = TasklistRouterImpl(view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
