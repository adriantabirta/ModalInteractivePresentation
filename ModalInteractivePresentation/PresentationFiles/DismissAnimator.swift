//
//  File.swift
//  ModalInteractivePresentation
//
//  Created by Adrian Tabirta on 02.03.2018.
//  Copyright © 2018 Adrian Tabirta. All rights reserved.
//

import UIKit

class DismissAnimator : NSObject,  UIViewControllerAnimatedTransitioning {
	
	private var dismissFinalFrame = CGRect.zero
	
	/**
	Init method
	- parameter margin: Distance from left, right and bottom.
	- parameter heightRation: Value for presented VC height, 0.5 is half of the screen.
	*/
	convenience init(margin: CGFloat, heightRatio: CGFloat) {
		self.init()
		dismissFinalFrame = CGRect(x: margin, y: screenHeight, width: screenWidth - (margin * 2), height: (screenHeight * 0.75))
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.25
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
			fromVC.view.frame = self.dismissFinalFrame
		}, completion: { _ in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
	}
}
