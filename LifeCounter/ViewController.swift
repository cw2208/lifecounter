//
//  ViewController.swift
//  LifeCounter
//
//  Created by Christina Wang on 1/31/26.
//
import UIKit

class ViewController: UIViewController {

    // Connect these in storyboard
    @IBOutlet weak var playersStack: UIStackView!
    @IBOutlet weak var addPlayerButton: UIButton!

    // Player data
    struct Player {
        var life: Int
    }

    var players: [Player] = []
    var history: [String] = []
    var gameStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start with 4 players at 20 life
        players = [Player(life: 20), Player(life: 20), Player(life: 20), Player(life: 20)]
        rebuildUI()
    }

    // Add Player button (max 8, disabled after game starts)
    @IBAction func addPlayerTapped(_ sender: UIButton) {
        if gameStarted { return }
        if players.count == 8 { return }

        players.append(Player(life: 20))
        rebuildUI()
    }

    // History button
    @IBAction func historyTapped(_ sender: UIButton) {
        let vc = HistoryViewController()
        vc.items = history
        navigationController?.pushViewController(vc, animated: true)
    }

    // Rebuild all player blocks
    func rebuildUI() {
        // remove old blocks
        for v in playersStack.arrangedSubviews {
            playersStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }

        // add blocks for each player
        for i in 0..<players.count {
            let block = makePlayerBlock(index: i)
            playersStack.addArrangedSubview(block)
        }
    }

    // One player UI block
    func makePlayerBlock(index: Int) -> UIView {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.spacing = 8

        // Player label
        let name = UILabel()
        name.textAlignment = .center
        name.text = "Player \(index + 1)"

        // Life label
        let lifeLabel = UILabel()
        lifeLabel.textAlignment = .center
        lifeLabel.font = UIFont.systemFont(ofSize: 40)
        lifeLabel.text = "\(players[index].life)"

        // Controls: [-] [amount] [+]
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.spacing = 8
        hstack.distribution = .fillEqually

        let minus = UIButton(type: .system)
        minus.setTitle("-", for: .normal)
        minus.tag = index
        minus.addTarget(self, action: #selector(minusTapped(_:)), for: .touchUpInside)

        let amountField = UITextField()
        amountField.text = "5"
        amountField.keyboardType = .numberPad
        amountField.borderStyle = .roundedRect
        amountField.textAlignment = .center
        amountField.tag = 1000 + index  // so we can find it later

        let plus = UIButton(type: .system)
        plus.setTitle("+", for: .normal)
        plus.tag = index
        plus.addTarget(self, action: #selector(plusTapped(_:)), for: .touchUpInside)

        hstack.addArrangedSubview(minus)
        hstack.addArrangedSubview(amountField)
        hstack.addArrangedSubview(plus)

        vstack.addArrangedSubview(name)
        vstack.addArrangedSubview(lifeLabel)
        vstack.addArrangedSubview(hstack)

        return vstack
    }

    // Read the number box (default 1 if empty)
    func getAmount(for index: Int) -> Int {
        let tf = playersStack.viewWithTag(1000 + index) as? UITextField
        let num = Int(tf?.text ?? "") ?? 1
        if num < 1 { return 1 }
        return num
    }

    // Mark game started (disable Add Player)
    func startGameIfNeeded() {
        if gameStarted == false {
            gameStarted = true
            addPlayerButton.isEnabled = false
        }
    }

    // + button
    @objc func plusTapped(_ sender: UIButton) {
        startGameIfNeeded()

        let i = sender.tag
        let amt = getAmount(for: i)

        players[i].life += amt
        history.append("Player \(i + 1) gained \(amt) life.")
        rebuildUI()
    }

    // - button
    @objc func minusTapped(_ sender: UIButton) {
        startGameIfNeeded()

        let i = sender.tag
        let amt = getAmount(for: i)

        players[i].life -= amt
        history.append("Player \(i + 1) lost \(amt) life.")
        rebuildUI()
    }
}


// Simple History screen (list)
class HistoryViewController: UIViewController, UITableViewDataSource {

    var items: [String] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "History"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

