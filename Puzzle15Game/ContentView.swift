//
//  ContentView.swift
//  Puzzle15Game
//
//  Created by GAPT on 25/07/25.
//

import SwiftUI

/// Representa la vista principal del juego del Rompecabezas de 15.
struct ContentView: View {
    
    // Instanciamos nuestro objeto de juego usando @StateObject.
    // @StateObject asegura que la instancia de PuzzleGame se cree una sola vez
    // y persista durante la vida útil de ContentView, y que ContentView
    // se actualice cuando PuzzleGame.board cambie.
    @StateObject private var game = PuzzleGame()
    
    // La estructura de datos del tablero, usando una matriz de enteros opcionales.
    // Por ahora, se inicializa con un tablero resuelto para fines de visualización estática.
    let board: [[Int?]] = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, nil] // 'nil' representa el espacio vacío
    ]
    var body: some View {
        // Un VStack centra verticalmente el tablero.
        VStack {
            // Título del juego con la 'R' y el '15' más grandes.
            HStack(spacing: 0) { // Usamos HStack con spacing: 0 para que los Text estén pegados
                Text("R") // La 'R' más grande
                    .font(.custom("PressStart2P-Regular", size: 80)) // Tamaño más grande para la 'R'
                    .fontWeight(.bold)
                    .shadow(radius: 4)
                Text("-") // El resto del texto
                    .font(.custom("PressStart2P-Regular", size: 40)) // Tamaño normal del título
                    .fontWeight(.bold)
                Text("15") // El '15' más grande
                    .font(.custom("PressStart2P-Regular", size: 80)) // Tamaño más grande para el '15'
                    .fontWeight(.bold)
                    .shadow(radius: 4)
            }
            .foregroundColor(.primary) // Aseguramos un color consistente para todo el título
            .padding(.bottom, 20)
            
            
            // Grid para organizar las piezas del rompecabezas.
            // Usamos LazyVGrid para un diseño de cuadrícula flexible.
            // columns: Un array de GridItem que define cómo se distribuyen las columnas.
            // En este caso, cuatro columnas flexibles que se adaptarán al espacio disponible.
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                // Iteramos sobre cada fila del tablero.
                
                ForEach(0..<game.board.count, id: \.self) { row in
                    // Iteramos sobre cada columna dentro de la fila.
                    ForEach(0..<game.board[row].count, id: \.self) { column in
                        // Accedemos al valor de la pieza en la posición actual.
                        let pieceValue = game.board[row][column]
                        
                        // Condicional para mostrar la pieza si no es nil (espacio vacío).
                        if let value = pieceValue {
                            // Vista de la pieza: un rectángulo con el número.
                            Text("\(value)")
                                .font(.custom("PressStart2P-Regular", size: 30))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, minHeight: 80) // Ocupa el ancho disponible, altura fija.
                                .background(Color.blue) // Color de fondo de la pieza.
                                .foregroundColor(.white) // Color del texto.
                                .cornerRadius(10) // Bordes redondeados.
                                .onTapGesture {
                                    print("ContentView: Pieza tocada en Fila: \(row), Columna: \(column)") //
                                    game.movePiece(atRow: row, column: column)
                                }
                        } else {
                            // Si es nil, mostramos un rectángulo vacío para el espacio.
                            // Esto mantiene la disposición de la cuadrícula.
                            Color.gray.opacity(0.3) // Un color tenue para el espacio vacío.
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .cornerRadius(10)
                            // Opcional: El espacio vacío también podría ser tocado,
                            // aunque no tiene efecto visible por sí mismo.
                                .onTapGesture {
                                    // No hacemos nada si el espacio vacío es tocado
                                    // o podríamos añadir lógica si fuera necesario.
                                    print("ContentView: Espacio vacío tocado en Fila: \(row), Columna: \(column)")
                                }
                        }
                    }
                }
            }
            .padding() // Añade un relleno alrededor de la cuadrícula.
            .aspectRatio(1, contentMode: .fit) // Asegura que el tablero sea cuadrado.
            .background(Color.gray.opacity(0.1)) // Fondo ligero para el área del tablero.
            .cornerRadius(15) // Bordes redondeados para el área del tablero.
            .shadow(radius: 5) // Una sombra sutil para darle profundidad.
            .animation(.easeInOut(duration: 0.2), value: game.board)
        }
        .padding() // Relleno general para la vista completa.
    }
}

// previsualización con #Preview
#Preview {
    ContentView()
}
