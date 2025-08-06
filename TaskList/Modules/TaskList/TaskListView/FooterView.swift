import UIKit

final class FooterView: UIView {
    
    // MARK: - Views
    
    lazy var numberOfTasksLabel: UILabel = .style {
        $0.text = "Задач нет"
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        $0.textColor = .mainText
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var createNewTaskButton: UIButton = .style {
        let image = UIImage(systemName: "square.and.pencil")
        $0.setImage(image, for: .normal)
        $0.tintColor = .golden
        $0.addTarget(self, action: #selector(self.createNewTaskButtonPressed), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var presenter: TaskListPresenter?
        
    // MARK: - Inits
    
    init(presenter: TaskListPresenter?) {
        super.init(frame: .zero)
        self.presenter = presenter
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        setupView()
        setupAutoLayout()
    }
    
    private func setupView() {
        backgroundColor = .footerBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberOfTasksLabel)
        addSubview(createNewTaskButton)
    }
    
    // MARK: - Private Methods
    
    @objc
    func createNewTaskButtonPressed() {
        presenter?.createNewTaskPressed()
    }
    
    // MARK: - AutoLayout
    
    private func setupAutoLayout() {
        setupNumberOfTasksLabelConstaints()
        setupCreateNewTaskButtonConstraints()
    }
    
    private func setupNumberOfTasksLabelConstaints() {
        numberOfTasksLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        numberOfTasksLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.5).isActive = true
    }
    
    private func setupCreateNewTaskButtonConstraints() {
        createNewTaskButton.centerYAnchor.constraint(equalTo: numberOfTasksLabel.centerYAnchor).isActive = true
        createNewTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22).isActive = true
        createNewTaskButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        createNewTaskButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
}
