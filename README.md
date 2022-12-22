# PashaKit

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
    .package(url: "https://github.com/muradtries/PashaKit.git", exact: "1.0.0"),
],
```

### Import and Use PashaKit
After the library has been added you can import the module to use it:

```Swift
import PashaKit
```

## List of Available Components
Following list of components are general purpose ones.
- PBUIButton
- PBUITextField
- PBRowView
- PBTemplateView
- PBPaddingLabel
- PBGradientView
- PBContactRowView
- PBCardInputView
- PBAttentionView
- PBElevatedView
- PBSelectableRowView

Beside them, kit also includes more specific components which has been used in our mobile applications. These include
- PBPaymentRowView
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

private lazy var pbButtonOutlined: PBUIButton = {
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
private lazy var textField2: PBUITextField = {
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


