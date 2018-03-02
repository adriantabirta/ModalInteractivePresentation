//
//  PresentAnimator.swift
//  ModalInteractivePresentation
//
//  Created by Adrian Tabirta on 02.03.2018.
//  Copyright © 2018 Adrian Tabirta. All rights reserved.
//

import UIKit

let margin 		  = CGFloat(15)
let screenWidth   = UIScreen.main.bounds.width
let screenHeight  = UIScreen.main.bounds.height

class PresentAnimator : NSObject, UIViewControllerAnimatedTransitioning {
	
	private var presentInitialFrame 	= CGRect.zero
	private var presentFinalFrame 		= CGRect.zero
	
	/**
	Init method
	- parameter margin: Distance from left, right and bottom.
	- parameter heightRation: Value for presented VC height, 0.5 is half of the screen.
	*/
	convenience init(margin: CGFloat, heightRatio: CGFloat) {
		self.init()
		presentInitialFrame = CGRect(x: margin, y: screenHeight, width: screenWidth - (margin * 2), height: (screenHeight * 0.75))
		presentFinalFrame 	= CGRect(x: margin, y: (screenHeight - (screenHeight * 0.75)) - margin, width: screenWidth - (margin * 2), height: (screenHeight * 0.75))
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.5
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let fromVC 	= transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
			let toVC 		= transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
		
		toVC.view.frame = presentInitialFrame
		transitionContext.containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveLinear, animations: {
			toVC.view.frame = self.presentFinalFrame
			
		}) { finished in
			transitionContext.completeTransition(finished)
		}
	}
}
