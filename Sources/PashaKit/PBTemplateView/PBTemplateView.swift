//
//  PBTemplateView.swift
//  
//
//  Created by Murad on 07.12.22.
//
//
//  MIT License
//
//  Copyright (c) 2022 Murad Abbasov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

///
/// `PBTemplateView` is UIView subclass made for displaying payment templates data.
///
/// **View Structure**
///
/// `PBTemplateView` consists of two main parts and their subviews:
/// - `iconWrapperView`- wrapper view for template icon
///     - `iconView` - view for holding template icon by default with the size of 48.0 by width and height
/// - `contentStackView`
///     - `titleLabel`- label for holding template name
///     - `subtitleLabel`- label for holding info about tempalte
///
/// When adding a template view to your interface, perform the following actions: 140
///
/// * Initialize it by selecting the type you wan to create
/// * Supply a height and width anchors to template view
/// * Supply a template icon via accessing its public `icon` property
/// * Set template data with the help of `setData(template: PBTemplateRepresentable)` function.
///
/// - Note: PBUIButton is optimized for looking as expected with default adjustments at the `height` and `width` of `140.0pt`.
///         However feel free to customize it the way you want.
///
public class PBTemplateView: UIView {

    /// Type of template view
    ///
    /// In our design system we are using different styles of template view for
    /// distinguishing payment view and template view.
    ///
    public enum ViewType {
        /// Payment type of template
        ///
        /// This type of payment changes `iconView` frame shape to circle.
        case payment

        /// Template type of template
        ///
        /// This type of payment changes `iconView` frame shape to rounded rectangle with the corner radius of `8.0`
        case template
    }

    public enum IconViewSize {
        case small
        case medium
    }

    /// Sets the type of template view
    ///
    /// By default this property has `template` value which will create view with *circular*
    /// template icon.
    ///
    public var viewType: ViewType = .template {
        didSet {
            switch self.viewType {
            case .payment:
                self.iconView.layer.cornerRadius = 24.0
            case .template:
                self.iconView.layer.cornerRadius = 8.0
            }
        }
    }

    /// Sets icon for template
    ///
    /// By default there is no template icon for view. If you specify it,
    /// template view will be created with an icon with proper corner radius for view type.
    ///
    public var icon: UIImage? {
        didSet {
            self.iconView.image = self.icon
        }
    }

    public var iconViewSize: IconViewSize = .small {
        didSet {
            switch self.iconViewSize {
            case .small:
                NSLayoutConstraint.activate(self.smallSizeConstraints)
                NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
            case .medium:
                NSLayoutConstraint.activate(self.mediumSizeConstraints)
                NSLayoutConstraint.deactivate(self.smallSizeConstraints)
            }
        }
    }

    var smallSizeConstraints: [NSLayoutConstraint] = []
    var mediumSizeConstraints: [NSLayoutConstraint] = []

    /// The title of template
    ///
    /// By default the title of template is empty string literal.
    ///
    /// If you specify it with desired title literal it will just set title text for template under template icon
    ///
    public var title: String? = "" {
        didSet {
            self.titleLabel.text = self.title
        }
    }

    /// The subtitle of template
    ///
    /// By default the subtitle of template is empty string literal.
    ///
    /// If you specify it with desired subtitle literal it will just set it for template under title label
    ///
    public var subtitle: String? = "" {
        didSet {
            self.subtitleLabel.text = self.subtitle
        }
    }

    private lazy var iconWrapperView: UIView = {
        let view = UIView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(red: 0.604, green: 0.608, blue: 0.612, alpha: 0.08)
        view.layer.cornerRadius = 24.0

        view.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        return view
    }()

    private lazy var iconView: UIImageView  = {
        let view = UIImageView()

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .scaleAspectFit

        return view
    }()


    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()

        self.addSubview(view)

        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 0

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .darkText
        label.textAlignment = .center
        label.text = self.title

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.514, alpha: 1)
        label.textAlignment = .center
        label.text = self.subtitle

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()


    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public convenience init(type: ViewType) {
        self.init(frame: .zero)
        self.setupViews(for: type)
    }

    private func setupViews(for type: ViewType) {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16.0
        self.layer.masksToBounds = true
        self.contentStackView.addArrangedSubview(self.titleLabel)
        self.contentStackView.addArrangedSubview(self.subtitleLabel)
        self.setupConstraints(for: type)

        switch type {
        case .payment:
            self.iconWrapperView.layer.cornerRadius = 24.0
        case .template:
            self.iconWrapperView.layer.cornerRadius = 8.0
        }
    }

    /// Sets data for a template view.
    ///
    /// - Parameters:
    ///    - template: Protocol for representing `templateView`.
    ///
    public func setData(template: PBTemplateRepresentable) {
        self.title = template.templateName
        self.subtitle = template.descriptionText
    }

    private func setupConstraints(for type: ViewType) {
        NSLayoutConstraint.activate([
            self.iconWrapperView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            self.iconWrapperView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        self.smallSizeConstraints = [
            self.iconView.topAnchor.constraint(equalTo: self.iconWrapperView.topAnchor, constant: 8.0),
            self.iconView.leftAnchor.constraint(equalTo: self.iconWrapperView.leftAnchor, constant: 8.0),
            self.iconView.bottomAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor, constant: -8.0),
            self.iconView.rightAnchor.constraint(equalTo: self.iconWrapperView.rightAnchor, constant: -8.0)
        ]

        self.mediumSizeConstraints = [
            self.iconView.topAnchor.constraint(equalTo: self.iconWrapperView.topAnchor),
            self.iconView.leftAnchor.constraint(equalTo: self.iconWrapperView.leftAnchor),
            self.iconView.bottomAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor),
            self.iconView.rightAnchor.constraint(equalTo: self.iconWrapperView.rightAnchor)
        ]

        switch type {
        case .payment:
            NSLayoutConstraint.activate(self.mediumSizeConstraints)
            NSLayoutConstraint.deactivate(self.smallSizeConstraints)
        case .template:
            NSLayoutConstraint.activate(self.smallSizeConstraints)
            NSLayoutConstraint.deactivate(self.mediumSizeConstraints)
        }

        NSLayoutConstraint.activate([
            self.contentStackView.topAnchor.constraint(equalTo: self.iconWrapperView.bottomAnchor, constant: 16.0),
            self.contentStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
            self.contentStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0)
        ])
    }
}
