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
    var leftNavigationController: UINavigationController? //TEST
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
    /**
     If the panel is not already expanded, call the addPanelViewController() and animatePanel(shouldExpand:) methods.
     */
    func expandPanel() {
        let notAlreadyExpanded = currentState != .productFilterExpanded
        
        if notAlreadyExpanded {
            addPanelViewController()
        }
        
        animatePanel(shouldExpand: notAlreadyExpanded)
    }
    
    /**
     Either expand the panel if it needs to be expanded, or do nothing, i.e. collapsed.
     */
    func collapsePanel() {
        switch currentState {
        case .productFilterExpanded: expandPanel()
        case .productFilterCollapsed: break
        }
    }
    
    /**
     Shows a shadow in the panel. (This isn't working.)
     - parameter shouldShowShadow: true if shadow should be shown
     */
    private func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        }
        else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    /**
     Helper function that adds adds the panel and handles any transferring of data between view controllers.
     */
    private func addPanelViewController() {
        guard leftNavigationController == nil else { return }
        
        // FIXME: - Test using Navigation Controller so I can have a Done button.
        if let nc = UIStoryboard.leftNavigationController {
            addChild(nc)
            nc.didMove(toParent: self)
            view.insertSubview(nc.view, at: 0)
            leftNavigationController = nc
            
            //This allows you to use the youDonePressedDone delegate function!!!
            let vc = nc.topViewController as! ProductFilterController
            vc.delegate = centerViewController
        }
        
        /*
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftViewController {
            // FIXME: Here is where you transfer data...?
            
//            addChildSidePanelController(vc) //defunct, now listing code down below
            addChild(vc)
            vc.didMove(toParent: self)
            view.insertSubview(vc.view, at: 0)
            vc.delegate = centerViewController
            
            leftViewController = vc
        }
         */
    }
    
/*
    private func addChildSidePanelController(_ sidePanelController: ProductFilterController) {
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
        view.insertSubview(sidePanelController.view, at: 0)
//        sidePanelController.delegate = centerViewController
    }
 */
    
    /**
    Animates the panel expanding/collapsing by calling the helper function animateCenterPanelXPosition.
     - parameter shouldExpand: true if it exanding, false if collapsing
     */
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
    
    /**
     Helper function to animatePanel. Handles the actual view animation.
     - parameters:
        - targetPosition: the end position after the animation has occurred
        - completion: completion handler, handles what to do after the animation completes
     */
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