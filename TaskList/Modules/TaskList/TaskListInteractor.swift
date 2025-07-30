import UIKit

protocol TaskListInteractor: AnyObject {
    init(_ presenter: TaskListPresenter)
}

final class TaskListInteractorImpl: TaskListInteractor {
    
    weak var presenter: TaskListPresenter?
        
    required init(_ presenter: TaskListPresenter) {
        self.presenter = presenter
    }
}
