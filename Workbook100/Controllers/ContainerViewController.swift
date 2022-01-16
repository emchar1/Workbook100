//
//  ContainerViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 1/15/22.
//

import UIKit

class ContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    let centerPanelExpandedOffset: CGFloat = 60
    var centerNavigationController: UINavigationController!
    var centerViewController: WorkbookViewController!
    var leftViewController: ProductFilterController?
    
    enum SlideOutState {
        case productFilterCollapsed, productFilterExpanded
    }
    
    var currentState: SlideOutState = .productFilterCollapsed {
        didSet {
            let shouldShowShadow = currentState != .productFilterCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        
        addChild(centerNavigationController)
        centerNavigationController.didMove(toParent: self)
        view.addSubview(centerNavigationController.view)
        
        //add pan gesture to slide out Product Filter Controller
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDragging = recognizer.velocity(in: view).x > 0
        
        switch recognizer.state {
        case .began:
            if currentState == .productFilterCollapsed {
                if gestureIsDragging {
                    addPanelViewController()
                }
                showShadowForCenterViewController(true)
            }
        case .changed:
            if let rView = recognizer.view {
                rView.center.x = rView.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(.zero, in: view)
            }
        case .ended:
            if let _ = leftViewController, let rView = recognizer.view {
                //Animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rView.center.x > view.bounds.size.width
                animatePanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
}


// MARK: - WorkbookViewControllerDelegate

extension ContainerViewController: WorkbookViewControllerDelegate {
    func expandPanel() {
        let notAlreadyExpanded = currentState != .productFilterExpanded
        
        if notAlreadyExpanded {
            addPanelViewController()
        }
        
        animatePanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapsePanel() {
        switch currentState {
        case .productFilterExpanded: expandPanel()
        case .productFilterCollapsed: break
        }
    }
    
    private func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        }
        else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    private func addPanelViewController() {
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftViewController {
            //Here is where you transfer data...?
            addChildSidePanelController(vc)
            leftViewController = vc
        }
    }
    
    private func addChildSidePanelController(_ sidePanelController: ProductFilterController) {
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
        view.insertSubview(sidePanelController.view, at: 0)
//        sidePanelController.delegate = centerViewController
    }
    
    private func animatePanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .productFilterExpanded
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
        }
        else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .productFilterCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    private func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}
