//
//  MainViewController.swift
//  EmojiDeconstructor
//
//  Created by Jennifer Starratt on 10/28/18.
//  Copyright © 2018 Jennifer Starratt. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController, UIKeyInput {
    /// Describes the state of the VC.
    enum Mode {
        case hasText
        case empty
    }
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    /// Displays the deconstructed emoji.
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var mode: Mode! {
        didSet {
            // Logical error if there is no mode.
            switch mode! {
            case .hasText:
                label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
                hasText = true
            case .empty:
                label.font = UIFont.preferredFont(forTextStyle: .body)
                label.text = NSLocalizedString("Pick an emoji to see how it is constructed 🛠", comment: "Instructions to pick an emoji")
                label.textColor = .lightGray
                hasText = false
            }
        }
    }
    
    var hasText = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Begin in empty mode.
        mode = .empty
        
        scrollView.addSubview(label)
        label.pin(to: scrollView.frameLayoutGuide)
        label.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.pin(to: view.layoutMarginsGuide)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var textInputMode: UITextInputMode? {
        // To start off with the emoji keyboard.
        // Future: create custom keyboard.
        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
    }
    
    func insertText(_ text: String) {
        // Assume text is empty at first.
        mode = .empty
        guard !text.isEmpty else { return }
        
        // ✨
        let unicodes: [String] = text.unicodeScalars.map { $0.escaped(asASCII: false) }
        label.text = unicodes.joined(separator: " ")
        mode = .hasText
    }
    
    func deleteBackward() {
        mode = .empty
        label.text = ""
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        /// Updates the safe area insets so the scroll view fits in the visible area.
        additionalSafeAreaInsets = contentInsets
    }
}

extension UIView {
    func pin(to guide: UILayoutGuide?) {
        guard let guide = guide else { return }
        topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
}
