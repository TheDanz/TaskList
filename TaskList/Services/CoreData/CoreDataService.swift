import CoreData

final class CoreDataService {
    
    // MARK: - Singleton
    
    static let shared = CoreDataService()
    
    private init() {}
    
    // MARK: - Properties
    
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
    
    // MARK: - Internal Methods
    
    func createTask(_ task: TaskEntity) {
        let taskModel = TaskModel(context: viewContext)
        taskModel.id = UUID().uuidString
        taskModel.title = task.title
        taskModel.depiction = task.description
        taskModel.creationDate = Date()
        taskModel.isDone = task.isDone
        
        try? viewContext.save()
    }
    
    func createTasks(_ tasks: [TaskEntity]) {
        for task in tasks {
            createTask(task)
        }
    }
    
    func deleteTask(object: TaskModel) {
        viewContext.delete(object)
        try? viewContext.save()
    }
    
    func updateTitle(with text: String, for task: TaskEntity) {
        let fetchRequest = TaskModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let taskToUpdate = results.first {
                taskToUpdate.title = text
                try viewContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateDescription(with text: String, for task: TaskEntity) {
        let fetchRequest = TaskModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let taskToUpdate = results.first {
                taskToUpdate.depiction = text
                try viewContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateIsDone(with value: Bool, for task: TaskEntity) {
        let fetchRequest = TaskModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let taskToUpdate = results.first {
                taskToUpdate.isDone = value
                try viewContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
