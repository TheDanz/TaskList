import UIKit
import CoreData

protocol TaskListInteractor: AnyObject {    
    func loadInitialTasks() async
    
    var taskCountWithWord: String { get }
    
    func numberOfTasks(in section: Int?) -> Int
    func getTask(at: IndexPath) -> TaskEntity
    func deleteTask(at: IndexPath)
    
    func setIsDone(value: Bool, for task: TaskEntity)
}

final class TaskListInteractorImpl: NSObject, TaskListInteractor {
    
    // MARK: - Properties
        
    private var networkRepository = NetworkRepository(networkService: NetworkService())
    private var userDefaults = UserDefaultsService()
    private var coreData = CoreDataService.shared
    
    private var fetchLimit = 1000
    var fetchedResultsController: NSFetchedResultsController<TaskModel>!
    
    // MARK: Inits
            
    override init() {
        super.init()
        setupFetchedResultsContoller()
    }
    
    // MARK: - Computed Properties
    
    var taskCountWithWord: String {
        let numberOfTasks = numberOfTasks(in: 0)
        return "\(numberOfTasks) \(taskWord(for: numberOfTasks))"
    }
    
    // MARK: - Internal Methods
    
    func loadInitialTasks() async {
        
        guard userDefaults.isFirstLaunch else { return }
        userDefaults.isFirstLaunch = false
                
        do {
            let response = try await networkRepository.fetchTasks()
            let entities = response.todos.map {
                TaskEntityImpl(
                    id: String($0.id),
                    title: "Задача #" + String($0.id),
                    description: $0.todo,
                    creationDate: Date(),
                    isDone: $0.completed
                )
            }
            coreData.createTasks(entities)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func numberOfTasks(in section: Int? = nil) -> Int {
        if let section {
            return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        } else {
            return fetchedResultsController.sections?.reduce(0) { $0 + $1.numberOfObjects } ?? 0
        }
    }
    
    func getTask(at: IndexPath) -> TaskEntity {
        let taskModel = fetchedResultsController.object(at: at)
        
        return TaskEntityImpl(
            id: taskModel.id,
            title: taskModel.title,
            description: taskModel.depiction,
            creationDate: taskModel.creationDate,
            isDone: taskModel.isDone
        )
    }
    
    func deleteTask(at: IndexPath) {
        let taskModel = fetchedResultsController.object(at: at)
        coreData.deleteTask(object: taskModel)
    }
    
    // MARK: - Private Methods
    
    private func setupFetchedResultsContoller() {
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = fetchLimit
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    private func taskWord(for count: Int) -> String {
        let lastTwoDigits = count % 100
        let lastDigit = count % 10
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "Задач"
        }
        
        switch lastDigit {
        case 1:
            return "Задача"
        case 2, 3, 4:
            return "Задачи"
        default:
            return "Задач"
        }
    }
    
    func setIsDone(value: Bool, for task: TaskEntity) {
        coreData.updateIsDone(with: value, for: task)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TaskListInteractorImpl: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) { }
}
