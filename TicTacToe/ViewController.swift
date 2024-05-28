//
//  ViewController.swift
//  TicTacToe
//
//  Created by Batu on 24.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    enum Turn {
        case Nought
        case Cross
    }
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    
    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    
    var NOUGHT = "O"
    var CROSS = "X"
    var board = [UIButton]()
    
    var noughtScore = 0
    var crossesScore = 0
    @IBOutlet weak var turnLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        
    }
    func initBoard() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)
    }
    
    func checkForVictory(_ s: String) -> Bool {
        // Horizontal Victory
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s) { return true }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s) { return true }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s) { return true }
        
        // Vertical Victory
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s) { return true }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s) { return true }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s) { return true }
        
        // Diagonal Victory
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s) { return true }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s) { return true }
        
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    func resultAlert(title: String) {
        let message = "\nNoughts: \(noughtScore)\nCrosses: \(crossesScore)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        firstTurn = firstTurn == .Nought ? .Cross : .Nought
        currentTurn = firstTurn
        turnLabel.text = currentTurn == .Nought ? NOUGHT : CROSS
    }
    
    func fullBoard() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    
    func addToBoard(_ sender: UIButton) {
        if sender.title(for: .normal) == nil {
            if currentTurn == .Nought {
                sender.setTitle(NOUGHT, for: .normal)
                currentTurn = .Cross
                turnLabel.text = CROSS
            } else if currentTurn == .Cross {
                sender.setTitle(CROSS, for: .normal)
                currentTurn = .Nought
                turnLabel.text = NOUGHT
            }
            sender.isEnabled = false
            
            // Check for victory or draw after player's move
            if checkForVictory(CROSS) {
                crossesScore += 1
                resultAlert(title: "Crosses Win!")
            } else if checkForVictory(NOUGHT) {
                noughtScore += 1
                resultAlert(title: "Noughts Win!")
            } else if fullBoard() {
                resultAlert(title: "Draw")
            } else {
                // If the game is not over, let the computer make a move
                if currentTurn == .Cross {
                    computerMove()
                    
                    // Check for victory or draw after computer's move
                    if checkForVictory(CROSS) {
                        crossesScore += 1
                        resultAlert(title: "Crosses Win!")
                    } else if checkForVictory(NOUGHT) {
                        noughtScore += 1
                        resultAlert(title: "Noughts Win!")
                    } else if fullBoard() {
                        resultAlert(title: "Draw")
                    }
                }
            }
        }
    }
    
    func computerMove() {
        var availableButtons: [UIButton] = []
        for button in board {
            if button.title(for: .normal) == nil {
                availableButtons.append(button)
            }
        }
        if let selectedButton = availableButtons.randomElement() {
            addToBoard(selectedButton)
        }
    }
}
