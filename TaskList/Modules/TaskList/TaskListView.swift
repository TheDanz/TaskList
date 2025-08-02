import UIKit

protocol TaskListView: AnyObject {
    func displayTasks(_ tasks: [TaskListEntity])
}

final class TaskListViewImpl: UIViewController {
    
    private var tasks: [TaskListEntity] = []
    private var userDefaults = UserDefaultsService()
    
    // MARK: - Properties
    
    var presenter: TaskListPresenter!
    var assambly: TaskListAssambly = TaskListAssamblyImpl()
    
    // MARK: - Views
    
    private lazy var titleLabel = UIView.style { (label: UILabel) in
        let font = UIFont.systemFont(ofSize: 34, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.mainText
        ]
        let text = "Задачи"
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.text = text
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var searchTextField = SearchTextField()
    private lazy var footerView = FooterView()
    
    private lazy var tasksTableView = UIView.style { (tableView: UITableView) in
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.backgroundColor = .mainBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assambly.configure(view: self)
        setupUI()
        
        Task {
            if userDefaults.isFirstLaunch {
                userDefaults.isFirstLaunch = false
                print("first")
                await presenter.loadTasks()
            }
        }
    }
    
    // MARK: - UI
    
    private func setupUI() {
        setupView()
        setupAutoLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(footerView)
        view.addSubview(tasksTableView)
    }
    
    // MARK: - AutoLayout
    
    private func setupAutoLayout() {
        setupTitleLabelConstraints()
        setupSearchTextFieldConstraints()
        setupFooterViewConstraints()
        setupTasksTableViewConstraints()
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupSearchTextFieldConstraints() {
        searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private func setupFooterViewConstraints() {
        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTasksTableViewConstraints() {
        tasksTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16).isActive = true
        tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tasksTableView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
    }
}

extension TaskListViewImpl: TaskListView {
    func displayTasks(_ tasks: [TaskListEntity]) {
        self.tasks = tasks
        DispatchQueue.main.async { [weak self] in
            self?.tasksTableView.reloadData()
        }
    }
}

extension TaskListViewImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: tasks[indexPath.row])
        return cell
    }
}

final class SearchTextField: UITextField {
    
    // MARK: - Inits
    
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
        setupTextField()
        setupLeftView()
        setupPlaceholder()
        setupRightView()
    }
    
    private func setupTextField() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        borderStyle = .none
        backgroundColor = .searchTextFieldBackground
        textColor = .searchTextFieldElements
        font = .systemFont(ofSize: 17, weight: .regular)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLeftView() {
        let magnifyingGlassImage = UIImage(systemName: "magnifyingglass")
        let imageView = UIImageView(image: magnifyingGlassImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 6, y: 0, width: 20, height: 22)
        imageView.tintColor = .searchTextFieldElements

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 22))
        containerView.addSubview(imageView)
        
        leftView = containerView
        leftViewMode = .always
    }
    
    private func setupRightView() {
        let microphoneImage = UIImage(systemName: "mic.fill")
        let imageView = UIImageView(image: microphoneImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 8, y: 7, width: 17, height: 22)
        imageView.tintColor = .searchTextFieldElements
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 36))
        containerView.addSubview(imageView)
        
        rightView = containerView
        rightViewMode = .always
    }
    
    private func setupPlaceholder() {
        placeholder = "Search"
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.searchTextFieldElements,
            .font: font
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
    }
}

final class FooterView: UIView {
    
    // MARK: - Views
    
    private lazy var numberOfTasksLabel = UIView.style { (label: UILabel) in
        let font = UIFont.systemFont(ofSize: 11, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.mainText
        ]
        let text = "Задач нет"
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.text = text
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var rightImageView = UIView.style { (imageView: UIImageView) in
        let image = UIImage(systemName: "square.and.pencil")
        imageView.image = image
        imageView.tintColor = .golden
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
        
    // MARK: - Inits
    
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
        addSubview(rightImageView)
    }
    
    // MARK: - AutoLayout
    
    private func setupAutoLayout() {
        setupNumberOfTasksLabelConstaints()
        setupRightIconConstraints()
    }
    
    private func setupNumberOfTasksLabelConstaints() {
        numberOfTasksLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        numberOfTasksLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.5).isActive = true
    }
    
    private func setupRightIconConstraints() {
        rightImageView.centerYAnchor.constraint(equalTo: numberOfTasksLabel.centerYAnchor).isActive = true
        rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22).isActive = true
        rightImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
}

final class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    
    private lazy var isDoneImageView = UIView.style { (imageView: UIImageView) in
        let image = UIImage(systemName: "circle")
        imageView.image = image
        imageView.tintColor = .uncompletedCircle
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.isDoneButtonPressed))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    private lazy var titleLabel = UIView.style { (label: UILabel) in
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.mainText
        ]
        let text = "No title"
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.text = text
        label.attributedText = attributedString
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var descriptionLabel = UIView.style { (label: UILabel) in
        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.mainText
        ]
        let text = "lond decription"
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.text = text
        label.attributedText = attributedString
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var creationDateLabel = UIView.style { (label: UILabel) in
        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.searchTextFieldElements
        ]
        let text = "31/07/2025"
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.text = text
        label.attributedText = attributedString
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(with task: TaskListEntity) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        creationDateLabel.text = formatter.string(from: task.creationDate)
                
        if task.isDone {
            isDoneImageView.image = UIImage(systemName: "checkmark.circle")
            isDoneImageView.tintColor = .golden
            titleLabel.textColor = .searchTextFieldElements
            descriptionLabel.textColor = .searchTextFieldElements
            
            let text = titleLabel.text ?? ""
            let attributedString = NSAttributedString(
                string: text,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )

            titleLabel.attributedText = attributedString
            
            let destext = descriptionLabel.text ?? ""
            let attributedStringdes = NSAttributedString(
                string: destext,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )

            descriptionLabel.attributedText = attributedStringdes
            
        } else {
            isDoneImageView.image = UIImage(systemName: "circle")
            isDoneImageView.tintColor = .uncompletedCircle
            titleLabel.textColor = .mainText
            descriptionLabel.textColor = .mainText
        }
    }
    
    @objc
    private func isDoneButtonPressed() {
        if let currentImage = isDoneImageView.image,
           currentImage == UIImage(systemName: "checkmark.circle") {
            isDoneImageView.image = UIImage(systemName: "checkmark.circle")
            isDoneImageView.tintColor = .systemGreen
        } else {
            isDoneImageView.image = UIImage(systemName: "circle")
            isDoneImageView.tintColor = .uncompletedCircle
        }
    }
    
    private func setupUI() {
        setupView()
        setupAutoLayout()
    }
    
    private func setupView() {
        backgroundColor = .mainBackground
        addSubview(isDoneImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(creationDateLabel)
    }
    
    private func setupAutoLayout() {
        setupIsDoneImageViewConstraints()
        setupTitleLabelConstraints()
        setupDescriptionLabelConstraints()
        setupCreationDateLabelConstraints()
    }
    
    private func setupIsDoneImageViewConstraints() {
        isDoneImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        isDoneImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        isDoneImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        isDoneImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.centerYAnchor.constraint(equalTo: isDoneImageView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: isDoneImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupDescriptionLabelConstraints() {
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: isDoneImageView.trailingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupCreationDateLabelConstraints() {
        creationDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6).isActive = true
        creationDateLabel.leadingAnchor.constraint(equalTo: isDoneImageView.trailingAnchor, constant: 8).isActive = true
        creationDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        creationDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }
}
