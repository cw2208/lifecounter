//
//  ViewController.swift
//  LifeCounter
//
//  Created by Christina Wang on 1/31/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playersStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.playersStack.axis =
                size.width > size.height ? .horizontal : .vertical
        })
    }
}


