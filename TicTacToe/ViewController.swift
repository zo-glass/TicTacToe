//
//  TicTacToe, ViewController.swift
//  macOS 13.2, Swift 5.0
//
//  Created by zo_glass
//

import UIKit

//MARK: - Enums

enum Player {
    case X
    case O
    case None
}

enum GameStatus {
    case XWin
    case OWin
    case Draw
    case Playing
}

// MARK: - UIViewController

class ViewController: UIViewController {
    
    //MARK: - Attributes
    
    var grid: [Player] = [.None, .None, .None,
                           .None, .None, .None,
                           .None, .None, .None]
    let winPositions: [[Int]] = [[0, 1, 2], [3, 4, 5], [6, 7, 8],   // Horizontal
                                [0, 3, 6], [1, 4, 7], [2, 5, 8],    // Vertical
                                [0, 4, 8], [2, 4, 6]]               // Diagonal
    var isPlaying: Bool = true
    var currentPlayer: Player = .X
    var counter: Int = 0
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var gridSpaceCollection: [UIButton]!
    @IBOutlet weak var clearGridButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearGrid()
    }
    
    //MARK: - IBActions
    
    @IBAction func gridSpaceTapped(_ sender: Any) {
        guard let btn = sender as? UIButton else { fatalError("gridSpaceTapped Failed") }
        let btnTag: Int = btn.tag
        
        if grid[btnTag] == .None && isPlaying {
            grid[btnTag] = currentPlayer
            counter+=1
            
            if currentPlayer == .X {
                btn.setTitle("X", for: .normal)
                currentPlayer = .O
                subtitleLabel.text = "O Turn"
            } else {
                btn.setTitle("O", for: .normal)
                currentPlayer = .X
                subtitleLabel.text = "X Turn"
            }
            
            let gameStatus: GameStatus = checkGameStatus()
            switch gameStatus {
            case .XWin:
                subtitleLabel.text = "X Win"
                isPlaying = false
            case .OWin:
                subtitleLabel.text = "O Win"
                isPlaying = false
            case .Draw:
                subtitleLabel.text = "Draw"
                isPlaying = false
            default:
                break
            }
            
            clearGridButton.isHidden = false
        }
    }
    
    @IBAction func clearGridButtonTapped(_ sender: Any) {
        if isPlaying {
            let alert = UIAlertController(title: "Warnning", message: "The game is in progress.\nThis action cannot be undone.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Return", comment: "Default action"), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
                self.clearGrid()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            clearGrid()
        }
    }
    
    //MARK: - Methods
    
    func checkGameStatus() -> GameStatus {
        var currentStatus: GameStatus = .Playing
        var haveWinner: Bool = false
        
        for winPosition in winPositions {
            if grid[winPosition[0]] == grid[winPosition[1]] &&
                grid[winPosition[1]] == grid[winPosition[2]] &&
                grid[winPosition[0]] != .None {
                
                haveWinner = true
                
                if grid[winPosition[0]] == .X {
                    currentStatus = .XWin
                } else {
                    currentStatus = .OWin
                }
                
            }
        }
        
        if counter == 9 && !haveWinner {
            currentStatus = .Draw
        }
        
        return currentStatus
    }
    
    func clearGrid() {
        isPlaying = true
        currentPlayer = .X
        counter = 0
        clearGridButton.isHidden = true
        subtitleLabel.text = "X Turn"
        
        for i in 0..<grid.count {
            grid[i] = .None
            gridSpaceCollection[i].setTitle("", for: .normal)
        }
    }

}

