//
//  ViewController.swift
//  LifeCounter
//
//  Created by Christina Wang on 1/31/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playersStack: UIStackView!
    @IBOutlet weak var player1LifeLabel: UILabel!
    @IBOutlet weak var player2LifeLabel: UILabel!
    @IBOutlet weak var loserLabel: UILabel!

    private var p1Life = 20
    private var p2Life = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        loserLabel.text = ""
        updateLifeLabels()
        updateLoserLabel()

        // Set initial layout direction
        playersStack.axis = view.bounds.width > view.bounds.height ? .horizontal : .vertical
    }

    private func updateLifeLabels() {
        player1LifeLabel.text = "\(p1Life)"
        player2LifeLabel.text = "\(p2Life)"
    }

    private func updateLoserLabel() {
        if p1Life <= 0 {
            loserLabel.text = "Player 1 LOSES!"
        } else if p2Life <= 0 {
            loserLabel.text = "Player 2 LOSES!"
        } else {
            loserLabel.text = ""
        }
    }

    private func changeLife(player: Int, delta: Int) {
        if player == 1 {
            p1Life += delta
        } else {
            p2Life += delta
        }

        updateLifeLabels()
        updateLoserLabel()
    }

    @IBAction func p1Plus(_ sender: UIButton) { changeLife(player: 1, delta: 1) }
    @IBAction func p1Minus(_ sender: UIButton) { changeLife(player: 1, delta: -1) }
    @IBAction func p1Plus5(_ sender: UIButton) { changeLife(player: 1, delta: 5) }
    @IBAction func p1Minus5(_ sender: UIButton) { changeLife(player: 1, delta: -5) }

    @IBAction func p2Plus(_ sender: UIButton) { changeLife(player: 2, delta: 1) }
    @IBAction func p2Minus(_ sender: UIButton) { changeLife(player: 2, delta: -1) }
    @IBAction func p2Plus5(_ sender: UIButton) { changeLife(player: 2, delta: 5) }
    @IBAction func p2Minus5(_ sender: UIButton) { changeLife(player: 2, delta: -5) }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.playersStack.axis = size.width > size.height ? .horizontal : .vertical
        })
    }
}
