import UIKit

protocol TaskInfoView {
    
}

final class TaskInfoViewImpl: UIViewController {
    
    // MARK: - Inits
    
    init(task: TaskListEntity) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
