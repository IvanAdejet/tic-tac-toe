//
//  ContentView.swift
//  TicTacToe
//
//  Created by Mario Ivan Esquivel Tejeda on 25/06/25.
//  Bemol needs to review it

import SwiftUI

// This gets an array like ["X","X","X"] and the symbol to compare it
func isWinningLine(_ cells: [String], player: String) -> Bool {
    cells.allSatisfy { $0 == player }
}

struct ContentView: View {
    @State private var counterPlayerX = 0
    @State private var counterPlayerO = 0
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var counter = 0
    @State public var winner = false
    @State public var winnerSymbol = ""
    
    func checkWinner() {
        let currentPlayer = counter % 2 == 0 ? "O" : "X"
        
        // Check rows
        for row in 0..<3 {
            if isWinningLine(board[row], player: currentPlayer) {
                winner = true
                if currentPlayer == "X" {
                    counterPlayerX += 1
                } else {
                    counterPlayerO += 1
                }
                return
            }
        }

        // Check columns
        for col in 0..<3 {
            let column = [board[0][col], board[1][col], board[2][col]]
            if isWinningLine(column, player: currentPlayer) {
                winner = true
                if currentPlayer == "X" {
                    counterPlayerX += 1
                } else {
                    counterPlayerO += 1
                }
                return
            }
        }

        // Check diagonals
        let mainDiagonal = [board[0][0], board[1][1], board[2][2]]
        let antiDiagonal = [board[0][2], board[1][1], board[2][0]]

        if isWinningLine(mainDiagonal, player: currentPlayer) ||
           isWinningLine(antiDiagonal, player: currentPlayer) {
            winner = true
            if currentPlayer == "X" {
                counterPlayerX += 1
            } else {
                counterPlayerO += 1
            }
        }
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        counter = 0
        winner = false
    }
    
    var body: some View {
        Text("Tic Tac Toe Game !")
            .font(.largeTitle)
        
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            ForEach(0..<3, id: \.self) { row in
                GridRow {
                    ForEach(0..<3, id: \.self) { column in
                        Button(action: {
                            if board[row][column].isEmpty && winner == false {
                                board[row][column] = counter % 2 == 0 ? "X" : "O"
                                winnerSymbol = counter % 2 == 0 ? "X" : "O"
                                counter += 1
                                checkWinner()
                            }

                        }) {
                            Text(board[row][column])
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.3))
                                .font(.largeTitle)
                                .foregroundStyle(.red)
                                
                        }
                    } //Column forEach
                }
            } // Row forEach
        } // Grid
        Text("X has \(counterPlayerX) wins \n O has \(counterPlayerO) wins")
        
        .sheet(isPresented: $winner) {
            VStack{
                Text("\(winnerSymbol) has won")
                    .font(.title)
                Button("Play again"){
                    resetGame()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
