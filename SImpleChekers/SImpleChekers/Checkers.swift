//
//  Checkers.swift
//  SImpleChekers
//
//  Created by Alexey Krzywicki on 28.01.2023.
//

import Foundation

// MARK: - Main Checkers game class
class Checkers {
    
    // MARK: - Properties
    private var board: [[Piece?]]
    private var currentPlayer: PieceColor
    
    // MARK: - Initializers
    init() {
        self.board = [[Piece?]](repeating: [Piece?](repeating: nil, count: 8), count: 8)
        self.currentPlayer = .red
        
        for i in 0..<3 {
            for j in stride(from: i % 2, to: 8, by: 2) {
                self.board[i][j] = Piece(color: .red, type: .normal)
            }
        }

        for i in 5..<8 {
            for j in stride(from: i % 2, to: 8, by: 2) {
                self.board[i][j] = Piece(color: .black, type: .normal)
            }
        }

    }
    
    // MARK: - Private Methods
    private func displayBoard() {
        print("    ", terminator: "")
        for i in 0..<8 {
            print("\(i)", terminator: "  ")
        }
        print()
        for i in 0..<8 {
            print("\(i)  ", terminator: "")
            for j in 0..<8 {
                if let piece = self.board[i][j] {
                    print("[\(piece.color == .red ? "r" : "b")]", terminator: "")
                } else {
                    print("[ ]", terminator: "")
                }
            }
            print("")
        }
    }
    private func getMove() -> (Int, Int, Int, Int) {
        var move: (Int, Int, Int, Int) = (-1, -1, -1, -1)
        while (move.0 < 0 || move.0 > 7 || move.1 < 0 || move.1 > 7 || move.2 < 0 || move.2 > 7 || move.3 < 0 || move.3 > 7) {
            print("Current player: \(self.currentPlayer)")
            print("Enter your move (fromRow fromCol toRow toCol): ")
            let input = readLine()!
            let moveComponents = input.split(separator: " ")
            if (moveComponents.count != 4) {
                continue
            }
            move = (Int(moveComponents[0])!, Int(moveComponents[1])!, Int(moveComponents[2])!, Int(moveComponents[3])!)
        }
        return move
    }
    private func makeMove(_ move: (Int, Int, Int, Int)) -> Bool {
        let fromRow = move.0
        let fromCol = move.1
        let toRow = move.2
        let toCol = move.3
        
        if (self.board[fromRow][fromCol]?.color != self.currentPlayer) {
            print("Invalid move: You can only move your own pieces.")
            return false
        }
        
        if (self.board[toRow][toCol] != nil) {
            print("Invalid move: You can't move to a occupied spot.")
            return false
        }
        
        let deltaRow = abs(toRow - fromRow)
        let deltaCol = abs(toCol - fromCol)
        
        if (deltaRow != deltaCol) {
            print("Invalid move: You can only move diagonally.")
            return false
        }
        
        if (deltaRow != 1 && deltaRow != 2) {
            print("Invalid move: You can only move 1 or 2 spaces diagonally.")
            return false
        }
        
        if (deltaRow == 2) {
            let jumpedRow = (fromRow + toRow) / 2
            let jumpedCol = (fromCol + toCol) / 2
            if (self.board[jumpedRow][jumpedCol]?.color == self.currentPlayer) {
                print("Invalid move: You can't jump over your own pieces.")
                return false
            }
            if (self.board[jumpedRow][jumpedCol] == nil) {
                print("Invalid move: You can only jump over opponent pieces.")
                return false
            }
            self.board[jumpedRow][jumpedCol] = nil
        }
        
        var piece = self.board[fromRow][fromCol]
        self.board[toRow][toCol] = piece
        self.board[fromRow][fromCol] = nil
        
        if (toRow == 0 || toRow == 7) {
            piece?.type = .king
        }
        
        switch self.currentPlayer {
        case .red:
            self.currentPlayer = .black
        case .black:
            self.currentPlayer = .red
        }

        return true
    }
    
    // MARK: - Public Methods
    func play() {
        while (true) {
            self.displayBoard()
            let move = self.getMove()
            if (self.makeMove(move)) {
                var redCount = 0
                var blackCount = 0
                for i in 0..<8 {
                    for j in 0..<8 {
                        if (self.board[i][j]?.color == .red) {
                            redCount += 1
                        } else if (self.board[i][j]?.color == .black) {
                            blackCount += 1
                        }
                    }
                }
                if (redCount == 0) {
                    print("Black player wins!")
                    break
                } else if (blackCount == 0) {
                    print("Red player wins!")
                    break
                } else if (redCount == 1 && blackCount == 1) {
                    print("It's a tie!")
                    break
                }
            }
        }
    }
}
