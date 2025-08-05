import UIKit

final class FooterView: UIView {
    
    // MARK: - Views
    
    lazy var numberOfTasksLabel: UILabel = .style {
        $0.text = "Задач нет"
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        $0.textColor = .mainText
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var rightImageView: UIImageView = .style {
        let image = UIImage(systemName: "square.and.pencil")
        $0.image = image
        $0.tintColor = .golden
        $0.translatesAutoresizingMaskIntoConstraints = false
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
