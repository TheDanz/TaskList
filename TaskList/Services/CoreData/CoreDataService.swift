import CoreData

final class CoreDataService: NSObject {
    
    // MARK: Properties
    
    private var fetchLimit = 1000
    private lazy var viewContext = persistentContainer.viewContext
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var fetchedResultsController: NSFetchedResultsController<TaskModel>!
    
    // MARK: Inits

    override init() {
        super.init()
        setupFetchedResultsContoller()
    }
    
    // MARK: Internal Methods
    
    func createTask(_ task: TaskListEntity) {
        let taskModel = TaskModel(context: viewContext)
        taskModel.id = UUID().uuidString
        taskModel.title = task.title
        taskModel.depiction = task.description
        taskModel.creationDate = Date()
        taskModel.isDone = task.isDone
        
        try? viewContext.save()
    }
    
    func createTasks(_ tasks: [TaskListEntity]) {
        for task in tasks {
            createTask(task)
        }
        
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Private Methods
    
    private func setupFetchedResultsContoller() {
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = fetchLimit
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        try? fetchedResultsController.performFetch()
    }
}
