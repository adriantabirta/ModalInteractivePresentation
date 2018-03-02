//
//  CustomPresentationController.swift
//  ModalInteractivePresentation
//
//  Created by Adrian Tabirta on 02.03.2018.
//  Copyright © 2018 Adrian Tabirta. All rights reserved.
//

import UIKit

/**
References:

// Modal presentation with interantion dismiss.
https://github.com/ThornTechPublic/InteractiveModal

// Apple modal presentation demo app
https://developer.apple.com/library/content/samplecode/CustomTransitions/CustomViewControllerPresentationsandTransitions.zip
*/

class CustomPresentationController: UIPresentationController {
	
	private var interactor 			= Interactor()
	private var defaultBlurRadius 	= CGFloat(2) // * UIScreen.main.scale // radius for blur
	private var defaultAlpha	 	= CGFloat(0.25)
	
	private lazy var dimmingView: UIView? = {
		$0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(sender:))))
		$0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		$0.backgroundColor = UIColor.black
		$0.alpha = 0
		$0.isOpaque = false
		return $0
	}(UIView(frame: containerView?.frame ?? CGRect.zero))
	
	private lazy var blurView: VisualEffectView? = {
		$0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		$0.backgroundColor = .clear
		$0.isOpaque = false
		$0.blurRadius = 0
		return $0
	}(VisualEffectView(frame: containerView?.frame ?? CGRect.zero))
	
	convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, interactor: Interactor) {
		self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		self.interactor = interactor
	}
	
	override func presentationTransitionWillBegin() {
		
		guard let containerFrame = containerView?.bounds else { return }
		
		// add blur view
		self.containerView?.addSubview(blurView!)
		
		// add transparent black view
		self.containerView?.addSubview(dimmingView!)
		
		presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
			self.dimmingView?.alpha 	= self.defaultAlpha
			self.blurView?.blurRadius 	= self.defaultBlurRadius
		}, completion: nil)
	}
	
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		guard !completed else { return }
		dimmingView?.removeFromSuperview()
		blurView?.removeFromSuperview()
	}
	
	override func dismissalTransitionWillBegin() {
		let transitionCoordinator = self.presentingViewController.transitionCoordinator
		transitionCoordinator?.animate(alongsideTransition: { (context) in
			
			self.dimmingView?.alpha 	= 0
			
		}, completion: nil)
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		guard completed == true else { return }
		dimmingView?.removeFromSuperview()
		blurView?.removeFromSuperview()
	}
	
	@IBAction func dimmingViewTapped(sender: UITapGestureRecognizer) {
		self.presentedViewController.dismiss(animated: true, completion: nil)
	}
}

// MARK: UIViewControllerTransitioningDelegate

extension CustomPresentationController: UIViewControllerTransitioningDelegate {
	
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return self
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return PresentAnimator(margin: 15, heightRatio: 0.75)
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return DismissAnimator(margin: 15, heightRatio: 0.75)
	}
	
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactor.hasStarted ? interactor : nil
	}
}

