protocol TaskListPresenter: AnyObject {
    init(_ view: TaskListView)
}

final class TaskListPresenterImpl: TaskListPresenter {
    
    weak var view: TaskListView?
    var interactor: TaskListInteractor!
    var router: TaskListRouter!
    
    required init(_ view: TaskListView) {
        self.view = view
    }
}
