import UIKit

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
