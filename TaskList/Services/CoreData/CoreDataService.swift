import CoreData

final class CoreDataService {
    
    // MARK: Properties
    
    lazy var viewContext = persistentContainer.viewContext
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
    }
    
    func deleteTask(object: TaskModel) {
        viewContext.delete(object)
        try? viewContext.save()
    }
}
