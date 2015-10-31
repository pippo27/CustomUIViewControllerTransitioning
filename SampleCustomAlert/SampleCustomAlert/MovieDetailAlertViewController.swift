//
//  MovieDetailAlertViewController.swift
//  SampleCustomAlert
//
//  Created by Arthit Thongpan on 10/31/15.
//  Copyright © 2015 Arthit Thongpan. All rights reserved.
//

import UIKit

class AlertViewPresentationController : UIPresentationController {
    
    var backgroundDimmingView:UIView!
    override func presentationTransitionWillBegin() {
        
        presentedViewController.view.layer.cornerRadius = 6
        presentedViewController.view.layer.masksToBounds = true
        
        
        backgroundDimmingView = UIView(frame: CGRectZero)
        backgroundDimmingView.translatesAutoresizingMaskIntoConstraints = false
        backgroundDimmingView.alpha = 0
        backgroundDimmingView.backgroundColor = UIColor.blackColor()
        self.containerView?.addSubview(backgroundDimmingView)
        
        setupLayout()
        
        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ (context) -> Void in
            self.backgroundDimmingView.alpha = 0.7
        }, completion: nil)
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return false
    }
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            backgroundDimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ (context) -> Void in
            self.backgroundDimmingView.alpha = 0.0
            self.presentingViewController.view.transform = CGAffineTransformIdentity
            
        },completion: nil)
        
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView()?.frame = frameOfPresentedViewInContainerView()
        backgroundDimmingView.frame = (containerView?.bounds)!
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            backgroundDimmingView.removeFromSuperview()
        }
    }
    
    
    
    func setupLayout(){
        self.containerView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundDimmingView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["backgroundDimmingView":backgroundDimmingView]))
        self.containerView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundDimmingView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["backgroundDimmingView":backgroundDimmingView]))
    }

}

//MARK: - AnimatedTransitioning เปิด (fade in)
class AlertViewPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        transitionContext.containerView()?.addSubview(toViewController.view)
        
        let scale:CGFloat = 1.2
        toViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        toViewController.view.layer.opacity = 0.0
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
                toViewController.view.layer.transform = CATransform3DIdentity
                toViewController.view.layer.opacity = 1.0
            })
            { (finished) -> Void in
                transitionContext.completeTransition(true)
            }
    }
    
}

//MARK: - AnimatedTransitioning ตอนปิด (fade out)
class AlertViewDismissalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
                fromViewController.view.layer.opacity = 0.0
            })
            { (finished) -> Void in
                transitionContext.completeTransition(true)
            }
        
    }
}


class MovieDetailAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        transitioningDelegate = nil
        super.viewDidDisappear(animated)
    }
    
    @IBAction func onCloseButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = AlertViewPresentationController(presentedViewController: presented, presentingViewController: presenting)
        return presentationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let alertViewPresentationAnimationController = AlertViewPresentationAnimationController()
        return alertViewPresentationAnimationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let alertViewDismissalAnimationController = AlertViewDismissalAnimationController()
        return alertViewDismissalAnimationController
    }
}
