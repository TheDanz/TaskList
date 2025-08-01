protocol TaskListPresenter: AnyObject {
    init(_ view: TaskListView)
    
    func loadTasks() async
    func didFetchTasks(_ tasks: [TaskListEntity])
}

final class TaskListPresenterImpl: TaskListPresenter {
    
    weak var view: TaskListView?
    var interactor: TaskListInteractor!
    var router: TaskListRouter!
    
    required init(_ view: TaskListView) {
        self.view = view
    }

    func loadTasks() async {
        await interactor.fetchTasks()
    }
    
    func didFetchTasks(_ tasks: [TaskListEntity]) {
        view?.displayTasks(tasks)
    }
}
