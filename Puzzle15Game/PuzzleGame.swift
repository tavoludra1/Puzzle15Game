//
//  PuzzleGame.swift
//  Puzzle15Game
//
//  Created by GAPT on 26/07/25.
//

import Foundation
import Combine // Necesario para ObservableObject y @Published

/// Una clase que gestiona la lógica y el estado del Rompecabezas de 15.
/// Es un ObservableObject para que las vistas de SwiftUI puedan reaccionar a los cambios.
class PuzzleGame: ObservableObject {
    /// El tablero de juego, representado como una matriz bidimensional de enteros opcionales.
    /// @Published notifica a los suscriptores (ej. ContentView) cada vez que el tablero cambia.
    @Published var board: [[Int?]]
    
    @Published var isSolved: Bool = false
    
    /// Inicializador de la clase PuzzleGame.
    init() {
        // Primero inicializamos el tablero a un estado resuelto
        self.board = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
            [13, 14, 15, nil]
        ]
        // Luego lo barajamos. Esto asegura un tablero resoluble al inicio.
        shuffleBoard()
    }
    
    /// Realiza el movimiento de una pieza en el tablero, intercambiándola con el espacio vacío
    /// si la pieza está adyacente. Esta función es privada y es llamada internamente.
    /// - Parameters:
    ///   - row: Fila de la pieza a mover.
    ///   - column: Columna de la pieza a mover.
    private func performMove(atRow row: Int, column: Int) {
        // Usa la nueva función findPosition
        guard let emptyPos = findPosition(of: nil) else {
            print(
                "PuzzleGame: ERROR - Espacio vacío no encontrado durante performMove."
            )
            return
        }
        
        let er = emptyPos.row
        let ec = emptyPos.column
        
        let isAdjacent = (abs(row - er) == 1 && column == ec) || (
            abs(column - ec) == 1 && row == er
        )
        
        if isAdjacent {
            // Intercambiamos los valores
            let temp = board[row][column]
            board[row][column] = board[er][ec]
            board[er][ec] = temp
            
            // aquí se añaden las verificaciones de victoria.
            self.isSolved = checkWin()
            if self.isSolved {
                print("¡Juego Resuelto!") // Solo para depuración
            }
        }
    }
    
    
    /// Método público para que la vista solicite un movimiento de pieza.
    /// Este es el método que ContentView llamará.
    /// - Parameters:
    ///   - row: Fila de la pieza tocada.
    ///   - column: Columna de la pieza tocada.
    func playerMovePiece(atRow row: Int, column: Int) {
        // Simplemente llamamos a la función privada que contiene la lógica.
        performMove(atRow: row, column: column)
    }
    
    
    
    /// Función para mover una pieza si es adyacente al espacio vacío.
    /// - Parameters:
    ///   - row: La fila de la pieza a intentar mover.
    ///   - column: La columna de la pieza a intentar mover.
    func movePiece(atRow row: Int, column: Int) {
        // Primero, buscamos la posición del espacio vacío (nil).
        print(
            "PuzzleGame: movePiece llamado para Fila: \(row), Columna: \(column)"
        )
        var emptyRow: Int?
        var emptyCol: Int?
        
        for r in 0..<board.count {
            for c in 0..<board[r].count {
                if board[r][c] == nil {
                    emptyRow = r
                    emptyCol = c
                    break
                }
            }
            if emptyRow != nil {
                break
            } // Si ya lo encontramos, salimos del bucle exterior
        }
        
        // Aseguramos que encontramos el espacio vacío. Esto siempre debería ocurrir.
        guard let er = emptyRow, let ec = emptyCol else {
            print(
                "PuzzleGame: ERROR - Espacio vacío no encontrado. Esto no debería pasar."
            )
            return
        }
        
        print(
            "PuzzleGame: Espacio vacío encontrado en Fila: \(er), Columna: \(ec)"
        )
        
        // Verificamos si la pieza que el usuario tocó (row, column) es adyacente al espacio vacío.
        // Hay 4 posibles movimientos: arriba, abajo, izquierda, derecha.
        let isAdjacent = (abs(row - er) == 1 && column == ec) || (
            abs(column - ec) == 1 && row == er
        )
        
        if isAdjacent {
            print(
                "PuzzleGame: Pieza en (\(row), \(column)) ES adyacente al espacio vacío. Moviendo..."
            )
            // Si la pieza es adyacente, la intercambiamos con el espacio vacío.
            // Usamos 'temp' para guardar el valor de la pieza antes de moverla.
            let temp = board[row][column]
            board[row][column] = board[er][ec] // Mueve el 'nil' a la posición de la pieza.
            board[er][ec] = temp // Mueve la pieza a la posición del espacio vacío.
            print("PuzzleGame: Tablero después del movimiento: \(board)")
        } else {
            print(
                "PuzzleGame: Pieza en (\(row), \(column)) NO ES adyacente al espacio vacío. No se mueve."
            )
        }
    }
    
    
    /// Baraja el tablero realizando una serie de movimientos aleatorios válidos.
    /// Esto asegura que el tablero resultante siempre sea resoluble.
    func shuffleBoard() {
        // Resetea el tablero a su estado resuelto antes de barajar.
        // Esto es importante para asegurar un estado inicial conocido y resoluble.
        self.board = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
            [13, 14, 15, nil]
        ]
        
        let numberOfShuffles = 500 // Un número alto para asegurar un buen barajado
        
        for _ in 0..<numberOfShuffles {
            guard let emptyPos = findPosition(of: nil) else { continue } // Asegura que el espacio vacío existe
            
            let emptyRow = emptyPos.row
            let emptyCol = emptyPos.column
            
            // Definimos posibles movimientos para el espacio vacío
            var possibleMoves: [(Int, Int)] = [] // Array de tuplas (fila, columna) de piezas que se pueden mover
            
            // Revisa la pieza de arriba
            if emptyRow > 0 { possibleMoves.append((emptyRow - 1, emptyCol)) }
            // Revisa la pieza de abajo
            if emptyRow < 3 { possibleMoves.append((emptyRow + 1, emptyCol)) }
            // Revisa la pieza de la izquierda
            if emptyCol > 0 { possibleMoves.append((emptyRow, emptyCol - 1)) }
            // Revisa la pieza de la derecha
            if emptyCol < 3 { possibleMoves.append((emptyRow, emptyCol + 1)) }
            
            // Selecciona un movimiento aleatorio de las piezas adyacentes al espacio vacío.
            if let randomPieceToMove = possibleMoves.randomElement() {
                // Llama a performMove para mover la pieza seleccionada (intercambiándola con el espacio vacío)
                performMove(atRow: randomPieceToMove.0, column: randomPieceToMove.1)
            }
        }
    }
    
    
    
    /// Verifica si el tablero actual está en el estado resuelto.
    /// - Returns: `true` si el tablero está resuelto, `false` en caso contrario.
    func checkWin() -> Bool {
        // El estado resuelto es 1, 2, ..., 15, nil.
        // Convertimos el tablero actual en una secuencia lineal para comparar.
        var linearizedBoard: [Int?] = []
        for row in board {
            for element in row {
                linearizedBoard.append(element)
            }
        }
        
        // El estado objetivo resuelto: 1, 2, ..., 15, nil
        let solvedState: [Int?] = Array(1...15).map { Optional($0) } + [nil]
        
        // Comparamos el tablero linealizado con el estado resuelto ideal.
        return linearizedBoard == solvedState
    }
    
    
    
    
    
    
    /// Encuentra la fila y columna de un valor específico (o nil para el espacio vacío) en el tablero.
    /// - Parameter value: El entero a buscar, o nil para el espacio vacío.
    /// - Returns: Una tupla (row, column) si se encuentra el valor, o nil si no está presente.
    private func findPosition(of value: Int?) -> (row: Int, column: Int)? {
        for r in 0..<board.count {
            for c in 0..<board[r].count {
                if board[r][c] == value {
                    return (row: r, column: c)
                }
            }
        }
        return nil
    }
}
