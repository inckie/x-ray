//
//  PopupViewController.swift
//
//  Created by Apple on 03/09/21.
//

import UIKit

public protocol PopupViewControllerDelegate: AnyObject {
    func popupViewControllerDidDismissByTapGesture(_ sender: PopupViewController)
}

public extension PopupViewControllerDelegate {
    func popupViewControllerDidDismissByTapGesture(_ sender: PopupViewController) {}
}

open class PopupViewController: UIViewController {
    public enum PopupPosition {
        case center(CGPoint?)
        case topLeft(CGPoint?)
        case topRight(CGPoint?)
        case bottomLeft(CGPoint?)
        case bottomRight(CGPoint?)
        case top(CGFloat)
        case left(CGFloat)
        case bottom(CGFloat)
        case right(CGFloat)
        case offsetFromView(CGPoint? = nil, UIView)
    }

    open private(set) var popupWidth: CGFloat?
    open private(set) var popupHeight: CGFloat?
    open private(set) var position: PopupPosition = .center(nil)
    open var backgroundAlpha: CGFloat = 0.2
    open var backgroundColor = UIColor.clear
    open var canTapOutsideToDismiss = true
    open var cornerRadius: CGFloat = 0
    open var shadowEnabled = true
    open private(set) var contentController: UIViewController?
    open private(set) var contentView: UIView?
    open weak var delegate: PopupViewControllerDelegate?
    open var heightConstraint: NSLayoutConstraint?

    private var containerView = UIView()
    private var isViewDidLayoutSubviewsCalled = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(contentController: UIViewController, position: PopupPosition = .center(nil), popupWidth: CGFloat?, popupHeight: CGFloat?) {
        super.init(nibName: nil, bundle: nil)
        self.contentController = contentController
        contentView = contentController.view
        self.popupWidth = popupWidth
        self.popupHeight = popupHeight
        self.position = position

        commonInit()
    }

    public init(contentView: UIView, position: PopupPosition = .center(nil), popupWidth: CGFloat?, popupHeight: CGFloat?) {
        super.init(nibName: nil, bundle: nil)
        self.contentView = contentView
        self.popupWidth = popupWidth
        self.popupHeight = popupHeight
        self.position = position

        commonInit()
    }

    private func commonInit() {
        modalPresentationStyle = .pageSheet
        modalTransitionStyle = .coverVertical
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addDismissGesture()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if isViewDidLayoutSubviewsCalled == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupViews()
            }
        }

        isViewDidLayoutSubviewsCalled = true
    }

    private func addDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTapGesture(gesture:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = backgroundColor.withAlphaComponent(backgroundAlpha)

        if cornerRadius > 0 {
            contentView?.layer.cornerRadius = cornerRadius
            contentView?.layer.masksToBounds = true
        }

        if shadowEnabled {
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.shadowColor = UIColor.clear.cgColor
            containerView.layer.shadowRadius = 3
        }
    }

    private func setupViews() {
        if let contentController = contentController {
            addChild(contentController)
        }

        addViews()
        addSizeConstraints()
        addPositionConstraints()
    }

    private func addViews() {
        view.addSubview(containerView)

        if let contentView = contentView {
            containerView.addSubview(contentView)

            let topConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
        }
    }

    private func addSizeConstraints() {
        if let popupWidth = popupWidth {
            let widthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: popupWidth)
            NSLayoutConstraint.activate([widthConstraint])
        }

        if let popupHeight = popupHeight {
            heightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: popupHeight)

            guard let heightConstraint = heightConstraint else {
                return
            }
            NSLayoutConstraint.activate([heightConstraint])
        }
    }

    private func addPositionConstraints() {
        switch position {
        case let .center(offset):
            addCenterPositionConstraints(offset: offset)

        case let .topLeft(offset):
            addTopLeftPositionConstraints(offset: offset, anchorView: nil)

        case let .topRight(offset):
            addTopRightPositionConstraints(offset: offset)

        case let .bottomLeft(offset):
            addBottomLeftPositionConstraints(offset: offset)

        case let .bottomRight(offset):
            addBottomRightPositionConstraints(offset: offset)

        case let .top(offset):
            addTopPositionConstraints(offset: offset)

        case let .left(offset):
            addLeftPositionConstraints(offset: offset)

        case let .bottom(offset):
            addBottomPositionConstraints(offset: offset)

        case let .right(offset):
            addRightPositionConstraints(offset: offset)

        case let .offsetFromView(offset, anchorView):
            addTopLeftPositionConstraints(offset: offset, anchorView: anchorView)
        }
    }

    private func addCenterPositionConstraints(offset: CGPoint?) {
        let centerXConstraint = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: offset?.x ?? 0)
        let centerYConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: offset?.y ?? 0)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }

    private func addTopLeftPositionConstraints(offset: CGPoint?, anchorView: UIView?) {
        var position: CGPoint = offset ?? .zero

        if let anchorView = anchorView {
            let anchorViewPosition = view.convert(CGPoint.zero, from: anchorView)
            position = CGPoint(x: position.x + anchorViewPosition.x, y: position.y + anchorViewPosition.y)
        }

        let topConstraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: position.y)
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: position.x)
        NSLayoutConstraint.activate([topConstraint, leftConstraint])
    }

    private func addTopRightPositionConstraints(offset: CGPoint?) {
        let topConstraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: offset?.y ?? 0)
        let rightConstraint = NSLayoutConstraint(item: view as Any, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: offset?.x ?? 0)
        NSLayoutConstraint.activate([topConstraint, rightConstraint])
    }

    private func addBottomLeftPositionConstraints(offset: CGPoint?) {
        let bottomConstraint = NSLayoutConstraint(item: view as Any, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: offset?.y ?? 0)
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: offset?.x ?? 0)
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint])
    }

    private func addBottomRightPositionConstraints(offset: CGPoint?) {
        let bottomConstraint = NSLayoutConstraint(item: view as Any, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: offset?.y ?? 0)
        let rightConstraint = NSLayoutConstraint(item: view as Any, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: offset?.x ?? 0)
        NSLayoutConstraint.activate([bottomConstraint, rightConstraint])
    }

    private func addTopPositionConstraints(offset: CGFloat) {
        let topConstraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: offset)
        let centerXConstraint = NSLayoutConstraint(item: view as Any, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConstraint, centerXConstraint])
    }

    private func addLeftPositionConstraints(offset: CGFloat) {
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: offset)
        let centerYConstraint = NSLayoutConstraint(item: view as Any, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leftConstraint, centerYConstraint])
    }

    private func addBottomPositionConstraints(offset: CGFloat) {
        let bottomConstraint = NSLayoutConstraint(item: view as Any, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: offset)
        let centerXConstraint = NSLayoutConstraint(item: view as Any, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([bottomConstraint, centerXConstraint])
    }

    private func addRightPositionConstraints(offset: CGFloat) {
        let rightConstraint = NSLayoutConstraint(item: view as Any, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: offset)
        let centerXConstraint = NSLayoutConstraint(item: view as Any, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([rightConstraint, centerXConstraint])
    }

    @objc func dismissTapGesture(gesture: UIGestureRecognizer) {
        dismiss(animated: true) {
            self.delegate?.popupViewControllerDidDismissByTapGesture(self)
        }
    }
}

extension PopupViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view, canTapOutsideToDismiss else {
            return false
        }

        return !touchView.isDescendant(of: containerView)
    }
}
