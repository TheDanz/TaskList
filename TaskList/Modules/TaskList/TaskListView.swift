import UIKit

protocol TaskListView: AnyObject {
    
}

final class TaskListViewImpl: UIViewController {
    var assambly: TaskListAssambly = TaskListAssamblyImpl()
    var presenter: TaskListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        assambly.configure(view: self)
    }
}

extension TaskListViewImpl: TaskListView {
    
}
