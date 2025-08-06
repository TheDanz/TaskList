import Foundation

protocol TaskInfoInteractor: AnyObject {
    func titleTextViewDidChange(with text: String, for task: TaskEntity)
    func descriptionTextViewDidChange(with text: String, for task: TaskEntity)
    func createEmptyTask() -> TaskEntity
}

final class TaskInfoInteractorImpl: TaskInfoInteractor {
    
    private let coreData = CoreDataService.shared
    
    func titleTextViewDidChange(with text: String, for task: TaskEntity) {
        coreData.updateTitle(with: text, for: task)
    }
    
    func descriptionTextViewDidChange(with text: String, for task: TaskEntity) {
        coreData.updateDescription(with: text, for: task)
    }
    
    func createEmptyTask() -> TaskEntity {
        
        let title = "Новая задача"
        let description = "Описание новой задачи"
        
        let taskModel = coreData.createEmptyTask(title: title, description: description)
        
        return TaskEntityImpl(
            id: taskModel.id,
            title: taskModel.title,
            description: taskModel.depiction,
            creationDate: taskModel.creationDate,
            isDone: taskModel.isDone
        )
    }
}
