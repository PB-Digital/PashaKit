import UIKit

open class PBCardRowView: UIView, PBSkeletonable {

    public var rightIcon: UIImage? {
        didSet {
            self.rightIconView.image = self.rightIcon
        }
    }

    private lazy var primaryStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 16.0

        return view
    }()

    private lazy var secondaryStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 0.0

        return view
    }()

    private lazy var cardImageView: UIImageView = {
        let view = UIImageView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true

        view.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 60.0).isActive = true

        return view
    }()

    private lazy var issuerLogo: UIImageView = {
        let view = UIImageView()

        self.cardImageView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit
        
        view.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 18.0).isActive = true

        return view
    }()

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkText
        label.text = "1.00 ₼"

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.514, alpha: 1)
        label.text = "0000 • Visa debit"

        return label
    }()

    private lazy var rightIconWrapperView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 18.0).isActive = true

        return view
    }()

    private lazy var rightIconView: UIImageView = {
        let view = UIImageView()

        self.rightIconWrapperView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.setImage(withName: "ic_chevron_right")
        view.contentMode = .scaleAspectFit

        return view
    }()

    required public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }

    public convenience init(rightIcon: UIImage?) {
        self.init(frame: .zero)
        self.setupViews()
        self.rightIconView.image = rightIcon
    }

    public func setData(card: PBCardRepresentable) {

        self.balanceLabel.text = card.balance
        self.descriptionLabel.text = card.displayName
        self.issuerLogo.image = card.issuerLogoClear
        self.cardImageView.setGradientBackground(gradientConfig: card.backgroundConfig)
    }

    private func setupViews() {

        self.primaryStackView.addArrangedSubview(self.cardImageView)
        self.primaryStackView.addArrangedSubview(self.secondaryStackView)
        self.secondaryStackView.addArrangedSubview(self.balanceLabel)
        self.secondaryStackView.addArrangedSubview(self.descriptionLabel)
        self.primaryStackView.addArrangedSubview(self.rightIconWrapperView)

        self.setupConstraints()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.primaryStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 14.0),
            self.primaryStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.primaryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14.0),
            self.primaryStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            self.issuerLogo.topAnchor.constraint(equalTo: self.cardImageView.topAnchor, constant: 6.0),
            self.issuerLogo.leftAnchor.constraint(equalTo: self.cardImageView.leftAnchor, constant: 6.0)
        ])

        NSLayoutConstraint.activate([
            self.rightIconView.topAnchor.constraint(equalTo: self.rightIconWrapperView.topAnchor, constant: 3.0),
            self.rightIconView.leftAnchor.constraint(equalTo: self.rightIconWrapperView.leftAnchor, constant: 3.0),
            self.rightIconView.bottomAnchor.constraint(equalTo: self.rightIconWrapperView.bottomAnchor, constant: -3.0),
            self.rightIconView.rightAnchor.constraint(equalTo: self.rightIconWrapperView.rightAnchor, constant: -3.0),
        ])

        NSLayoutConstraint.activate([
            self.rightIconWrapperView.centerYAnchor.constraint(equalTo: self.primaryStackView.centerYAnchor)
        ])
    }

    public func showSkeletonAnimation() {
        self.issuerLogo.showAnimatedGradientSkeleton()
        self.balanceLabel.showAnimatedGradientSkeleton()
        self.descriptionLabel.showAnimatedGradientSkeleton()
    }

    public func hideSkeletonAnimation() {
        self.issuerLogo.hideSkeleton()
        self.balanceLabel.hideSkeleton()
        self.descriptionLabel.hideSkeleton()
    }
}
