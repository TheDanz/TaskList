import Foundation

protocol TaskListPresenter: AnyObject {
    init(_ view: TaskListView)
    
    func loadInitialTasks() async
    
    func editContextMenuButtonPressed(for task: TaskListEntity)
    func shareContextMenuButtonPressed(for task: TaskListEntity)
    
    func numberOfTasks(in section: Int) -> Int
    func getTask(at: IndexPath) -> TaskListEntity
    func deleteTask(at: IndexPath)
}

final class TaskListPresenterImpl: TaskListPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskListView?
    var interactor: TaskListInteractor!
    var router: TaskListRouter!
    
    // MARK: - Inits
    
    required init(_ view: TaskListView) {
        self.view = view
    }
    
    // MARK: Internal Methods

    func loadInitialTasks() async {
        await interactor.loadInitialTasks()
        view?.reloadData()
    }
    
    func editContextMenuButtonPressed(for task: TaskListEntity) { }
    func shareContextMenuButtonPressed(for task: TaskListEntity) { }
    
    func numberOfTasks(in section: Int) -> Int {
        interactor.numberOfTasks(in: section)
    }
    
    func getTask(at: IndexPath) -> TaskListEntity {
        interactor.getTask(at: at)
    }
    
    func deleteTask(at: IndexPath) {
        interactor.deleteTask(at: at)
        view?.deleteRows(at: [at])
    }
}
