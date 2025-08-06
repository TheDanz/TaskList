import UIKit

protocol TaskListView: AnyObject {
    func reloadData()
    func updateNumberOfTasksLabel(with text: String)
    func deleteRows(at: [IndexPath])
}

final class TaskListViewImpl: UIViewController {
    
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
    
    private lazy var searchTextField: SearchTextField = .style {
        $0.delegate = self
        $0.addTarget(self, action: #selector(self.searchTextChanged), for: .editingChanged)
    }
    private lazy var footerView = FooterView(presenter: presenter)
    
    private lazy var tasksTableView = UIView.style { (tableView: UITableView) in
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.backgroundColor = .mainBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: ViewController LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.tasksTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assambly.configure(view: self)
        setupUI()

        Task { await presenter.loadInitialTasks() }
    }
    
    // MARK: - Private Methods
    
    @objc
    private func searchTextChanged() {
        guard let searchText = searchTextField.text?.lowercased() else { return }
        presenter.updateSearch(with: searchText)
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

// MARK: - TaskListView

extension TaskListViewImpl: TaskListView {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tasksTableView.reloadData()
        }
    }
    
    func updateNumberOfTasksLabel(with text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.footerView.numberOfTasksLabel.text = text
        }
    }
    
    func deleteRows(at: [IndexPath]) {
        tasksTableView.deleteRows(at: at, with: .automatic)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TaskListViewImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfTasks(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = presenter.getTask(at: indexPath)
        cell.configure(with: task, presenter: presenter)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            
            let editAction = UIAction(title: "Редактировать", image: .editIcon) { action in
                self.presenter.editContextMenuButtonPressed(for: self.presenter.getTask(at: indexPath))
            }
            
            let shareAction = UIAction(title: "Поделиться", image: .shareIcon) { action in
                self.presenter.shareContextMenuButtonPressed(for: self.presenter.getTask(at: indexPath))
            }

            let deleteAction = UIAction(title: "Удалить", image: .deleteIcon, attributes: .destructive) { action in
                self.presenter.deleteTask(at: indexPath)
            }
            
            return UIMenu(children: [editAction, shareAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            presenter.deleteTask(at: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = presenter.getTask(at: indexPath)
        presenter.didSelectTask(task)
    }
}

// MARK: - UITextFieldDelegate

extension TaskListViewImpl: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTextChanged()
        return true
    }
}
