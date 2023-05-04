# PashaKit iOS

PashaKit contains native UIKit components aligned with Pasha Bank's design system.

## Getting Started

### Installation Guide

#### Requirements

- iOS 12.0+
- Swift 5.7

#### Using Swift Package Manager

To integrate PashaKit, specify it as a dependency in your XCode project or <code>Package.swift</code> file:

```swift
dependencies: [
    .package(url: "https://github.com/PB-Digital/PashaKit.git", exact: "the_version_you_want"),
],
```

### Import and Use PashaKit iOS
After the library has been added you can import the module to use it:

```Swift
import PashaKit
```

## List of Available Components
Following list of components are general purpose ones.
- PBUIButton
- PBUITextField
- PBRowView
- PBPaddingLabel
- PBGradientView
- PBContactRowView
- PBCardInputView
- PBAttentionView
- PBElevatedView
- PBSelectableRowView

Beside them, kit also includes more specific components which has been used in our mobile applications. These include
- PBTemplateView
- PBPaymentRowView
- PBCardRowView
- PBTransactionRowView
- PBSelectableCardView
- PBAccountSelectField

## Dependencies
PashaKit has dependency from InputMask library for making textfield text to get formatted real-time
based on predefined rules. At the moment it uses 6.1.0 version of InputMask.

## PBUIButton
PBUIButton is one of the fundamental component of library. It comes with 4 different styles:
- Plain - with clear background color
- Tinted - with pale background color
- Filled - with solid background color
- Outlined - with clear background color and solid border color

To use PBUIButton you can initialize and customize it as following:

```swift
import PashaKit

private lazy var button: PBUIButton = {
        // If you didn't specify the style of button, it automatically sets its style as .filled
        let button = PBUIButton(localizableTitle: "Filled", styleOfButton: .filled)

        self.view.addSubview(button)

        return button
}()
```

Since PBUIButton is subclass of UIButton you are free to add button target to it. If you like working with gesture recognizers rather than targets, just set <code>isUserInteractionEnabled</code> value to <code>true</code> and start adding instructions.

## PBUITextfield

PBUITextfield has 2 different styles:
- Rounded
- Underlined

To use PBUIButton you can initialize and customize it as following:

```swift
private lazy var textField: PBUITextField = {
    // If you didn't specify the style of textfield, it automatically sets its style as rounded
    let view =  PBUITextField(style: .underlined)

    view.placeholderText = "Card Number"
    // Setting footer text beforehand, puts assigned text under border. It can be changed if 
    // you also did specify footer text invalid state. If yes, default footerlabel text gets
    // replaced with invalid state's text and returns back to default state once its input is valid
    view.footerLabelText = "Enter the 16 digits of card"

    // Puts an image to the right side of the textfield
    view.icon = UIImage(named: "ic_card_scaner_private")
    // Right side image varies in their sizes. Based on your design choice, you can choose
    // - small - 16x16
    // - regular - 24x24
    // - custom one
    view.iconSize = .regular

    // As specified abouve we are using input mask for masking textfield text real-time.
    // In this example we just set the text format for displaying card number grouped 
    // into 4 numbered digits
    view.maskFormat = "[0000] [0000] [0000] [0000]"
    view.setKeyboardType(.decimalPad)

    return view
}()
```

## PBRowView
PBRowView is a type of component which can be used as single view and also as table view cell. 

Using it as a <code>UITableViewCell</code> cell just requires you to subclass table view cell and adding rowview as a subview to that cell. most of the time you can just make constraints equal to cell from all sides. 

Usage

```swift
private lazy var rowView: PBRowView = {
    let view = PBRowView()

    // Layout preference allows you to swap order of subtitle and title texts.
    // By default its value is 'titleFirst' which shows title text above subtitle
    view.textLayoutPreference = .subtitleFirst
    view.titleText = "Title"
    view.subtitleText = "Subtitle"
    // Left icon is just for setting the image or icon on the left side of row view.
    view.leftIcon = UIImage(named: "image")
    // Sets leftIcon's parent view shape.
    // Right now it has 2 option:
    // - circle
    // - roundedRect(cornerRadius: CGFloat)
    // If not setted explicitly leftIcon's parent view draws itself as a circle
    view.leftIconStyle = .circle
    // By default edge insets of icon is equal to zero from all sides.
    // Use this property when you need smaller icon without changing size of parent view
    view.leftIconContentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    // By default left icon's parent view comes with pale gray color. If you have icon with clear background it can show unwanted results. 
    // For making the icon look as intented change this property's value
    view.leftIconBackgroundColor = .clear
    // The rightmost side of row view is for chevron icon. Change this property if you don't want chevron icon.
    view.isChevronIconVisible = false
    // Row view supports skeleton view. By calling this function it will show animated skeleton. Don't forget to call hideSkeletonAnimation()
    view.showSkeletonAnimation()

    return view
}()
```

## PBGradientView
PBGradientView can be used as subview to any UIView with the help of <code>setGradientBackground(gradientConfig: GradientBackgroundRepresentable)</code> function. It fills your view's background with configured gradient view setup.

This property was used to display small gradient version of our customer's card in PBCardRowView component.

```swift
public func setData(card: PBCardRepresentable) {
    self.balanceLabel.text = card.balance
    self.descriptionLabel.text = card.displayName
    self.issuerLogo.image = card.issuerLogoClear
    self.cardImageView.setGradientBackground(gradientConfig: card.backgroundConfig)
}
```
## PBContactRowView
Contact row view is very similar component to row view. But the main difference between is their left icons and right view. On contact view left icon is a UILabel with rounded corners shaped as a circle with text. It gets the texts from the first letters of title and subtitle text. On the right side it shows the user's short card info. These include:
- card issuer logo
- last 4 digits of customer's card

```swift 
private lazy var contactView: PBContactRowView = {
    let view = PBContactRowView()

    self.contentView.addSubview(view)

    // By default contact row view shows card issuer logo and its last 4 digits on the right side. If you don't need this view just set showsCardInfo to false
    view.showsCardInfo = false
    // By default contact rowview has pale gray background color.
    view.backgroundColor = .clear
    // You can use this property to set the background color for circle UILabel which used for displaying the first letters of contact's for name and surname
    view.shortLabelBackgroundColor = .systemBlue

    return view
}()
```
