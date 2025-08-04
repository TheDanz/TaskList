import Foundation

protocol TaskListPresenter: AnyObject {
    init(_ view: TaskListView)
    
    func loadInitialTasks() async
    func didLoadInitialTasks()
    
    func editContextMenuButtonPressed(for task: TaskListEntity)
    func shareContextMenuButtonPressed(for task: TaskListEntity)
    func deleteContextMenuButtonPressed(for task: TaskListEntity)
    
    func numberOfTasks(in section: Int) -> Int
    func getTask(at: IndexPath) -> TaskListEntity
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
    }
    
    func didLoadInitialTasks() {
        view?.reloadData()
    }
    
    func editContextMenuButtonPressed(for task: TaskListEntity) { }
    func shareContextMenuButtonPressed(for task: TaskListEntity) { }
    func deleteContextMenuButtonPressed(for task: TaskListEntity) { }
    
    func numberOfTasks(in section: Int) -> Int {
        interactor.numberOfTasks(in: section)
    }
    
    func getTask(at: IndexPath) -> TaskListEntity {
        interactor.getTask(at: at)
    }
}
