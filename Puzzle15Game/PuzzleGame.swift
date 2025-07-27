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

    /// Inicializador de la clase PuzzleGame.
    init() {
        // Inicializamos el tablero con una configuración resuelta para comenzar.
        // En futuros sprints, -> barajaremos las piezas.
        self.board = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
            [13, 14, 15, nil] // El espacio vacío
        ]
    }

    /// Función para mover una pieza si es adyacente al espacio vacío.
    /// - Parameters:
    ///   - row: La fila de la pieza a intentar mover.
    ///   - column: La columna de la pieza a intentar mover.
    func movePiece(atRow row: Int, column: Int) {
        // Primero, buscamos la posición del espacio vacío (nil).
        print("PuzzleGame: movePiece llamado para Fila: \(row), Columna: \(column)")
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
            if emptyRow != nil { break } // Si ya lo encontramos, salimos del bucle exterior
        }

        // Aseguramos que encontramos el espacio vacío. Esto siempre debería ocurrir.
        guard let er = emptyRow, let ec = emptyCol else {
            print("PuzzleGame: ERROR - Espacio vacío no encontrado. Esto no debería pasar.")
            return
        }
        
        print("PuzzleGame: Espacio vacío encontrado en Fila: \(er), Columna: \(ec)")

        // Verificamos si la pieza que el usuario tocó (row, column) es adyacente al espacio vacío.
        // Hay 4 posibles movimientos: arriba, abajo, izquierda, derecha.
        let isAdjacent = (abs(row - er) == 1 && column == ec) || (abs(column - ec) == 1 && row == er)

        if isAdjacent {
            print("PuzzleGame: Pieza en (\(row), \(column)) ES adyacente al espacio vacío. Moviendo...")
            // Si la pieza es adyacente, la intercambiamos con el espacio vacío.
            // Usamos 'temp' para guardar el valor de la pieza antes de moverla.
            let temp = board[row][column]
            board[row][column] = board[er][ec] // Mueve el 'nil' a la posición de la pieza.
            board[er][ec] = temp // Mueve la pieza a la posición del espacio vacío.
            print("PuzzleGame: Tablero después del movimiento: \(board)")
        } else {
            print("PuzzleGame: Pieza en (\(row), \(column)) NO ES adyacente al espacio vacío. No se mueve.")
        }
    }

    // Más lógica del juego (barajar, verificar victoria, etc.) se añadirán aquí en futuros sprints.
}
