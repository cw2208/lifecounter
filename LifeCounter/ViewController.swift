//
//  ViewController.swift
//  LifeCounter
//
//  Created by Christina Wang on 1/31/26.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playersStack: UIStackView!
    @IBOutlet weak var addPlayerButton: UIButton!

    struct Player {
        var name: String
        var life: Int
    }

    var players: [Player] = []
    var history: [String] = []
    var gameStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }

    @IBAction func addPlayerTapped(_ sender: UIButton) {
        if gameStarted { return }
        if players.count == 8 { return }

        players.append(Player(name: "Player \(players.count + 1)", life: 20))
        rebuildUI()
    }

    @IBAction func historyTapped(_ sender: UIButton) {
        let vc = HistoryViewController()
        vc.items = history
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func resetTapped(_ sender: UIButton) {
        resetGame()
    }

    func resetGame() {
        players = [
            Player(name: "Player 1", life: 20),
            Player(name: "Player 2", life: 20),
            Player(name: "Player 3", life: 20),
            Player(name: "Player 4", life: 20)
        ]
        history = []
        gameStarted = false
        addPlayerButton.isEnabled = true
        rebuildUI()
    }

    func rebuildUI() {
        for v in playersStack.arrangedSubviews {
            playersStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }

        for i in 0..<players.count {
            let block = makePlayerBlock(index: i)
            playersStack.addArrangedSubview(block)
        }
    }

    func makePlayerBlock(index: Int) -> UIView {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.spacing = 8

        let nameButton = UIButton(type: .system)
        nameButton.setTitle(players[index].name, for: .normal)
        nameButton.tag = index
        nameButton.addTarget(self, action: #selector(nameTapped(_:)), for: .touchUpInside)

        let lifeLabel = UILabel()
        lifeLabel.textAlignment = .center
        lifeLabel.font = UIFont.systemFont(ofSize: 40)
        lifeLabel.text = "\(players[index].life)"

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
        amountField.tag = 1000 + index

        let plus = UIButton(type: .system)
        plus.setTitle("+", for: .normal)
        plus.tag = index
        plus.addTarget(self, action: #selector(plusTapped(_:)), for: .touchUpInside)

        hstack.addArrangedSubview(minus)
        hstack.addArrangedSubview(amountField)
        hstack.addArrangedSubview(plus)

        vstack.addArrangedSubview(nameButton)
        vstack.addArrangedSubview(lifeLabel)
        vstack.addArrangedSubview(hstack)

        return vstack
    }

    func getAmount(for index: Int) -> Int {
        let tf = playersStack.viewWithTag(1000 + index) as? UITextField
        let num = Int(tf?.text ?? "") ?? 1
        if num < 1 { return 1 }
        return num
    }

    func startGameIfNeeded() {
        if gameStarted == false {
            gameStarted = true
            addPlayerButton.isEnabled = false
        }
    }

    func checkGameOver() {
        let aliveCount = players.filter { $0.life >= 0 }.count
        if gameStarted && aliveCount <= 1 {
            let alert = UIAlertController(title: "Game over!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.resetGame()
            })
            present(alert, animated: true)
        }
    }

    @objc func plusTapped(_ sender: UIButton) {
        startGameIfNeeded()

        let i = sender.tag
        let amt = getAmount(for: i)

        players[i].life += amt
        history.append("\(players[i].name) gained \(amt) life.")
        rebuildUI()
        checkGameOver()
    }

    @objc func minusTapped(_ sender: UIButton) {
        startGameIfNeeded()

        let i = sender.tag
        let amt = getAmount(for: i)

        players[i].life -= amt
        history.append("\(players[i].name) lost \(amt) life.")
        rebuildUI()
        checkGameOver()
    }

    @objc func nameTapped(_ sender: UIButton) {
        let i = sender.tag

        let alert = UIAlertController(title: "Rename Player", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.text = self.players[i].name
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let newName = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if newName.isEmpty { return }
            self.players[i].name = newName
            self.rebuildUI()
        })
        present(alert, animated: true)
    }
}

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
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
