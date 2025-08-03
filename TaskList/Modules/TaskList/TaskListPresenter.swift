protocol TaskListPresenter: AnyObject {
    init(_ view: TaskListView)
    
    func loadTasks() async
    func didFetchTasks(_ tasks: [TaskListEntity])
    
    func editContextMenuButtonPressed(for task: TaskListEntity)
    func shareContextMenuButtonPressed(for task: TaskListEntity)
    func deleteContextMenuButtonPressed(for task: TaskListEntity)
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
    
    func editContextMenuButtonPressed(for task: TaskListEntity) { }
    
    func shareContextMenuButtonPressed(for task: TaskListEntity) { }
    
    func deleteContextMenuButtonPressed(for task: TaskListEntity) { }
}
