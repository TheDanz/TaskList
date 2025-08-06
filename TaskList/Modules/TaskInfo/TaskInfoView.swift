import UIKit

protocol TaskInfoView: AnyObject {
    
}

final class TaskInfoViewImpl: UIViewController, TaskInfoView {
    
    // MARK: - Properties
    
    var presenter: TaskInfoPresenter!
    var assambly: TaskInfoAssambly = TaskInfoAssamblyImpl()
    
    private var task: TaskEntity? {
        didSet {
            guard let task else { return }
            configure(with: task)
        }
    }
    
    // MARK: - Views
    
    private lazy var titleTextView: UITextView = .style {
        $0.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        $0.textColor = .mainText
        $0.backgroundColor = .mainBackground
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var creationDateLabel: UILabel = .style {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .searchTextFieldElements
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var descriptionTextView: UITextView = .style {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .mainText
        $0.backgroundColor = .mainBackground
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Inits
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(task: TaskEntity) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assambly.configure(view: self)
        setupUI()
        
        if task == nil {
            let newTask = presenter.createEmptyTask()
            self.task = newTask
        }
        
        if let task {
            configure(with: task)
        }
    }
    
    // MARK: - UI
    
    private func configure(with task: TaskEntity) {
        titleTextView.text = task.title
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        creationDateLabel.text = formatter.string(from: task.creationDate)
        descriptionTextView.text = task.description
    }
 
    private func setupUI() {
        setupView()
        setupNavigationController()
        setupAutoLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
        view.addSubview(titleTextView)
        view.addSubview(creationDateLabel)
        view.addSubview(descriptionTextView)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .golden
    }
    
    // MARK: - AutoLayout
    
    private func setupAutoLayout() {
        setupTitleTextViewConstraints()
        setupCreationDateLabelConstraints()
        setupDescriptionTextViewConstraints()
    }
    
    private func setupTitleTextViewConstraints() {
        titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupCreationDateLabelConstraints() {
        creationDateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8).isActive = true
        creationDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        creationDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupDescriptionTextViewConstraints() {
        descriptionTextView.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: 16).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
}

extension TaskInfoViewImpl: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case titleTextView:
            if let task {
                presenter.titleTextViewDidChange(with: titleTextView.text, for: task)
            }
        case descriptionTextView:
            if let task {
                presenter.descriptionTextViewDidChange(with: descriptionTextView.text, for: task)
            }
        default:
            break
        }
    }
}
