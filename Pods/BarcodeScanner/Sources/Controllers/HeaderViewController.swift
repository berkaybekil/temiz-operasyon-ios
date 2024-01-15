import UIKit

/// Delegate to handle touch event of the close button.
protocol HeaderViewControllerDelegate: class {
  func headerViewControllerDidTapCloseButton(_ controller: HeaderViewController)
  func headerViewControllerDidTapManuelButton(_ controller: HeaderViewController)
}


/// View controller with title label and close button.
/// It will be added as a child view controller if `BarcodeScannerController` is being presented.
public final class HeaderViewController: UIViewController {
  weak var delegate: HeaderViewControllerDelegate?

  // MARK: - UI properties

  /// Header view with title label and close button.
  public private(set) lazy var navigationBar: UINavigationBar = self.makeNavigationBar()
  /// Title view of the navigation bar.
  public private(set) lazy var titleLabel: UILabel = self.makeTitleLabel()
  /// Left bar button item of the navigation bar.
  public private(set) lazy var closeButton: UIButton = self.makeCloseButton()
    
  public private(set) lazy var manuelButton: UIButton = self.makeManuelButton()

  // MARK: - View lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.delegate = self
    closeButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
    manuelButton.addTarget(self, action: #selector(handleManuelButtonTap), for: .touchUpInside)

    view.addSubview(navigationBar)
    setupConstraints()
  }

  // MARK: - Actions

  @objc private func handleCloseButtonTap() {
    delegate?.headerViewControllerDidTapCloseButton(self)
  }
    
    @objc private func handleManuelButtonTap() {
        delegate?.headerViewControllerDidTapManuelButton(self)
    }

  // MARK: - Layout

  private func setupConstraints() {
    NSLayoutConstraint.activate(
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    )

    if #available(iOS 11, *) {
      navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    } else {
      navigationBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
  }
}

// MARK: - Subviews factory

private extension HeaderViewController {
  func makeNavigationBar() -> UINavigationBar {
    let navigationBar = UINavigationBar()
    navigationBar.isTranslucent = false
    navigationBar.backgroundColor = .white
    navigationBar.items = makeNavigationItemRight()
   
    return navigationBar
  }

  func makeNavigationItem() -> UINavigationItem {
    let navigationItem = UINavigationItem()
    closeButton.sizeToFit()
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    titleLabel.sizeToFit()
    navigationItem.titleView = titleLabel
    return navigationItem
  }
    
    func makeNavigationItemRight() -> [UINavigationItem] {
        let navigationItem = UINavigationItem()
        manuelButton.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: manuelButton)
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        return [navigationItem]
    }

  func makeTitleLabel() -> UILabel {
    let label = UILabel()
    label.text = localizedString("SCAN_BARCODE_TITLE")
    label.font = UIFont.boldSystemFont(ofSize: 17)
    label.textColor = .black
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
  }

  func makeCloseButton() -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(localizedString("BUTTON_CLOSE"), for: UIControlState())
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    button.tintColor = .black
    return button
  }
    
    func makeManuelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Manuel Gir", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tintColor = UIColor.init(red: 0, green: 171, blue: 102, alpha: 100)
        return button
    }
}

// MARK: - UINavigationBarDelegate

extension HeaderViewController: UINavigationBarDelegate {
  public func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
