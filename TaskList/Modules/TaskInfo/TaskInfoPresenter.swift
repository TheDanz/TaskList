protocol TaskInfoPresenter: AnyObject {
    init(_ view: TaskInfoView)
}

final class TaskInfoPresenterImpl: TaskInfoPresenter {
    
    weak var view: TaskInfoView?
    var interactor: TaskInfoInteractor!
    var router: TaskInfoRouter!
    
    required init(_ view: TaskInfoView) {
        self.view = view
    }
}
