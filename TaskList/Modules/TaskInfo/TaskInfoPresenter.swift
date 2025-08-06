protocol TaskInfoPresenter: AnyObject {
    init(_ view: TaskInfoView)
    
    func titleTextViewDidChange(with text: String, for task: TaskEntity)
    func descriptionTextViewDidChange(with text: String, for task: TaskEntity)
    func createEmptyTask() -> TaskEntity
}

final class TaskInfoPresenterImpl: TaskInfoPresenter {
    
    weak var view: TaskInfoView?
    var interactor: TaskInfoInteractor!
    var router: TaskInfoRouter!
    
    required init(_ view: TaskInfoView) {
        self.view = view
    }
    
    func titleTextViewDidChange(with text: String, for task: TaskEntity) {
        interactor.titleTextViewDidChange(with: text, for: task)
    }
    
    func descriptionTextViewDidChange(with text: String, for task: TaskEntity) {
        interactor.descriptionTextViewDidChange(with: text, for: task)
    }
    
    func createEmptyTask() -> TaskEntity {
        interactor.createEmptyTask()
    }
}
