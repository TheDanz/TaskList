import UIKit

protocol TaskListInteractor: AnyObject {
    init(_ presenter: TaskListPresenter)
    
    func loadInitialTasks() async
    
    func numberOfTasks(in section: Int) -> Int
    func getTask(at: IndexPath) -> TaskListEntity
}

final class TaskListInteractorImpl: TaskListInteractor {
    
    // MARK: - Properties
    
    weak var presenter: TaskListPresenter?
    
    private var networkRepository = NetworkRepository(networkService: NetworkService())
    private var userDefaults = UserDefaultsService()
    private var coreData = CoreDataService()
    
    // MARK: Inits
            
    required init(_ presenter: TaskListPresenter) {
        self.presenter = presenter
    }
    
    // MARK: Internal Methods
    
    func loadInitialTasks() async {
        
        guard userDefaults.isFirstLaunch else { return }
        userDefaults.isFirstLaunch = false
                
        do {
            let response = try await networkRepository.fetchTasks()
            let entities = response.todos.map {
                TaskListEntityImpl(
                    title: "Задача #" + String($0.id),
                    description: $0.todo,
                    creationDate: Date(),
                    isDone: $0.completed
                )
            }
            coreData.createTasks(entities)
            presenter?.didLoadInitialTasks()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func numberOfTasks(in section: Int) -> Int {
        coreData.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func getTask(at: IndexPath) -> TaskListEntity {
        
        let taskModel = coreData.fetchedResultsController.object(at: at)
        
        return TaskListEntityImpl(
            title: taskModel.title,
            description: taskModel.depiction,
            creationDate: taskModel.creationDate,
            isDone: taskModel.isDone
        )
    }
}
