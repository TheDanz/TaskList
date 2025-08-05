import Foundation

protocol TaskListPresenter: AnyObject {
    init(_ view: TaskListView)
    
    func loadInitialTasks() async
    
    func editContextMenuButtonPressed(for task: TaskEntity)
    func shareContextMenuButtonPressed(for task: TaskEntity)
    
    func numberOfTasks(in section: Int) -> Int
    func getTask(at: IndexPath) -> TaskEntity
    func deleteTask(at: IndexPath)
    
    func didSelectTask(_ task: TaskEntity)
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
        view?.updateNumberOfTasksLabel(with: interactor.taskCountWithWord)
    }
    
    func editContextMenuButtonPressed(for task: TaskEntity) {
        router.openTaskInfo(about: task)
    }
    
    func shareContextMenuButtonPressed(for task: TaskEntity) {
        router.openShareActivityVC(task: task)
    }
    
    func numberOfTasks(in section: Int) -> Int {
        interactor.numberOfTasks(in: section)
    }
    
    func getTask(at: IndexPath) -> TaskEntity {
        interactor.getTask(at: at)
    }
    
    func deleteTask(at: IndexPath) {
        interactor.deleteTask(at: at)
        view?.deleteRows(at: [at])
        view?.updateNumberOfTasksLabel(with: interactor.taskCountWithWord)
    }
    
    func didSelectTask(_ task: TaskEntity) {
        router.openTaskInfo(about: task)
    }
}
