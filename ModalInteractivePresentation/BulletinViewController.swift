//
//  BulletinViewController.swift
//  ModalInteractivePresentation
//
//  Created by Adrian Tabirta on 02.03.2018.
//  Copyright © 2018 Adrian Tabirta. All rights reserved.
//

import UIKit

class BulletinViewController: UIViewController {
	
	var interactor: Interactor? = nil
	
	@IBAction func close(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
		
		let percentThreshold: CGFloat = 0.55
		
		let translation = sender.translation(in: view)
		let progress = translation.y / 500
		
		guard let interactor = interactor else { return }
		
		switch sender.state {
		case .began:
			interactor.hasStarted = true
			dismiss(animated: true, completion: nil)
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
	
	func showHelperCircle(){
		let center = CGPoint(x: view.bounds.width * 0.5, y: 100)
		let small = CGSize(width: 30, height: 30)
		let circle = UIView(frame: CGRect(origin: center, size: small))
		circle.layer.cornerRadius = circle.frame.width/2
		circle.backgroundColor = UIColor.white
		circle.layer.shadowOpacity = 0.8
		circle.layer.shadowOffset = CGSize()
		view.addSubview(circle)
		UIView.animate(
			withDuration: 0.5,
			delay: 0.25,
			options: [],
			animations: {
				circle.frame.origin.y += 200
				circle.layer.opacity = 0
		},
			completion: { _ in
				circle.removeFromSuperview()
		}
		)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		showHelperCircle()
	}
}



