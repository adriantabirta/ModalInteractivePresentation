//
//  ViewController.swift
//  ModalInteractivePresentation
//
//  Created by Adrian Tabirta on 02.03.2018.
//  Copyright © 2018 Adrian Tabirta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let interactor = Interactor()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	@IBAction func presentAction() {
		
		let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BulletinViewController" ) as! BulletinViewController
		let pc = CustomPresentationController(presentedViewController: secondViewController, presenting: self, interactor: interactor)
		secondViewController.interactor = self.interactor
		secondViewController.transitioningDelegate = pc
		secondViewController.modalPresentationStyle = .custom
		self.present(secondViewController, animated: true, completion: nil)
	}

}

