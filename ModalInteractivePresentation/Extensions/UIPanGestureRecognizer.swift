//
//  UIPanGestureRecognizer.swift
//  ModalInteractivePresentation
//
//  Created by Adrian Tabirta on 02.03.2018.
//  Copyright © 2018 Adrian Tabirta. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
	
	func handleDismissFor(vc: UIViewController, with interactor: Interactor) {
		let percentThreshold: CGFloat = 0.55
		
		let translation = self.translation(in: view)
		let progress = translation.y / 500
		
		switch self.state {
		case .began:
			interactor.hasStarted = true
			vc.dismiss(animated: true, completion: nil)
		case .changed:
			interactor.shouldFinish = progress > percentThreshold
			interactor.update(progress)
		case .cancelled:
			interactor.hasStarted = false
			interactor.cancel()
		case .ended:
			interactor.hasStarted = false
			interactor.shouldFinish
				? interactor.finish()
				: interactor.cancel()
		default:
			break
		}
	}
}
