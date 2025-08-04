protocol TaskInfoAssambly: AnyObject {
    func configure(view: TaskInfoViewImpl)
}

final class TaskInfoAssamblyImpl: TaskInfoAssambly {
    func configure(view: TaskInfoViewImpl) {
        let presenter = TaskInfoPresenterImpl(view)
        let interactor = TaskInfoInteractorImpl()
        let router = TaskInfoRouterImpl(view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
