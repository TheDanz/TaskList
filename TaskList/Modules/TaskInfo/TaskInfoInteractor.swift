protocol TaskInfoInteractor: AnyObject {
    func titleTextViewDidChange(with text: String, for task: TaskEntity)
    func descriptionTextViewDidChange(with text: String, for task: TaskEntity)
}

final class TaskInfoInteractorImpl: TaskInfoInteractor {
    
    private let coreData = CoreDataService.shared
    
    func titleTextViewDidChange(with text: String, for task: TaskEntity) {
        coreData.updateTitle(with: text, for: task)
    }
    
    func descriptionTextViewDidChange(with text: String, for task: TaskEntity) {
        coreData.updateDescription(with: text, for: task)
    }
}
