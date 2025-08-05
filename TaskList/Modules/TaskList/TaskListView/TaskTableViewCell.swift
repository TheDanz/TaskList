import UIKit

final class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    
    private var presenter: TaskListPresenter?
    
    // MARK: - Views
    
    private lazy var isDoneImageView: UIImageView = .style {
        $0.image = UIImage(systemName: "circle")
        $0.tintColor = .uncompletedCircle
        $0.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.isDoneButtonPressed))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
    }
    
    private lazy var titleLabel: UILabel = .style {
        $0.text = "N/A"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .mainText
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var descriptionLabel: UILabel = .style {
        $0.text = "N/A"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .mainText
        $0.numberOfLines = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var creationDateLabel: UILabel = .style {
        $0.text = "N/A"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .searchTextFieldElements
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var task: TaskEntity?
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Internal Methods
    
    func configure(with task: TaskEntity, presenter: TaskListPresenter) {
        self.task = task
        self.presenter = presenter
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        creationDateLabel.text = formatter.string(from: task.creationDate)
        
        if task.isDone {
            applyDoneStyle(task: task)
        } else {
            applyUndoneStyle(task: task)
        }
    }
    
    // MARK: - Private Methods
    
    @objc
    private func isDoneButtonPressed() {
        
        guard let task else { return }
        
        if isDoneImageView.tintColor == .golden {
            applyUndoneStyle(task: task)
            presenter?.setIsDone(value: false, for: task)
        } else {
            applyDoneStyle(task: task)
            presenter?.setIsDone(value: true, for: task)
        }
    }
    
    private func applyDoneStyle(task: TaskEntity) {
        isDoneImageView.image = UIImage(systemName: "checkmark.circle")
        isDoneImageView.tintColor = .golden
        
        titleLabel.attributedText = strikeThroughStyle(for: task.title)
        titleLabel.textColor = .searchTextFieldElements

        descriptionLabel.attributedText = NSAttributedString(string: task.description)
        descriptionLabel.textColor = .searchTextFieldElements
    }

    private func applyUndoneStyle(task: TaskEntity) {
        isDoneImageView.image = UIImage(systemName: "circle")
        isDoneImageView.tintColor = .uncompletedCircle

        titleLabel.attributedText = NSAttributedString(string: task.title)
        titleLabel.textColor = .mainText
        
        descriptionLabel.attributedText = NSAttributedString(string: task.description)
        descriptionLabel.textColor = .mainText
    }

    private func strikeThroughStyle(for text: String) -> NSAttributedString {
        let strikeThroughEffect: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        
        return NSAttributedString(string: text, attributes: strikeThroughEffect)
    }

    // MARK: - UI
    
    private func setupUI() {
        setupView()
        setupContentView()
        setupAutoLayout()
    }
    
    private func setupView() {
        backgroundColor = .mainBackground
        selectionStyle = .none
        addSubview(isDoneImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(creationDateLabel)
    }
    
    private func setupContentView() {
        contentView.isUserInteractionEnabled = false
    }
    
    // MARK: - AutoLayout
    
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
        creationDateLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
}
