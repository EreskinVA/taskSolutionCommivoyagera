//
//  HelpsFunc.swift
//  TaskSolutionCommivoyagera
//
//  Created by E.Vladimir A. on 07.11.2017.
//  Copyright © 2017 E.Vladimir A. All rights reserved.
//

import Foundation

func searchWayGadnii(matrix: [[Double]] = [[],[]]) -> [Double]  {
    
    var way: [Double] = []
    var newMatrix = matrix
    var wayOld: [[Double]] = []
    
    var massivZnachenii: [Double] = []
    var massivPath: [[Double]] = []
    var slovar: [Double : [Double]] = [:]
    
    // формируем массивы и словарь для работы
    for row in 0..<matrix.count {
        for col in  0..<matrix.count {
            if matrix[row][col] != -1 {
                massivZnachenii.append(matrix[row][col])
                let path = [Double(row), Double(col)]
                massivPath.append(path)
                
                slovar[matrix[row][col]] = path
            }
        }
    }
    
    
    var price = 0.0
    for poisk in 0..<matrix.count-1 {
        
        if poisk == 0 {
            let minZnachenie = massivZnachenii.min()! // найдем минимальный путь
            wayOld.append(slovar[minZnachenie]!) // добавим путь в массив
            price += minZnachenie
            var znach = 0
            while znach < massivZnachenii.count { // удалим путь из оставшихся вариантов
                if massivZnachenii[znach] == minZnachenie {
                    massivZnachenii.remove(at: znach)
                    continue
                }
                znach += 1
            }
        } else {
            
            // формируем словарь возможных путей и массив минимальных значений
            
            var vozmSlovar: [Double : [Double]] = [:]
            var minMas: [Double] = []
            
            
            let wayOldLast = wayOld.last!
            for zapis in slovar { // формируем массив оставшихся путей
                let mas = zapis.value
                if mas[0] == wayOldLast[1] {
                    minMas.append(zapis.key)
                    vozmSlovar[zapis.key] = zapis.value
                }
            }
            
            let minZnachenie = minMas.min()! // найдем минимальный путь
            wayOld.append(vozmSlovar[minZnachenie]!) // добавим путь в массив
            price += minZnachenie
            var znach = 0
            while znach < massivZnachenii.count { // удалим путь из оставшихся вариантов
                if massivZnachenii[znach] == minZnachenie {
                    massivZnachenii.remove(at: znach)
                    continue
                }
                znach += 1
            }
            
        }
        // удаляем замыкающие маршруты
        let wayOldFirst = wayOld[0]
        let wayOldLast = wayOld.last!
        for zapis in slovar {
            let mas = zapis.value
            if mas[1] == wayOldFirst[0] || mas[1] == wayOldLast[1] {
                var i = 0
                while i < massivZnachenii.count { // удаляем из массива
                    if massivZnachenii[i] == zapis.key {
                        massivZnachenii.remove(at: i)
                        continue
                    }
                    i += 1
                }
                slovar[zapis.key] = nil // удаляем из словаря
            }
        }
        
    }
    let pathN = [wayOld[wayOld.count-1][1],wayOld[0][0]]
    wayOld.append(pathN)
    price += matrix[Int(wayOld[0][0])][Int(wayOld[wayOld.count-1][1])]
    
    for i in 0..<wayOld.count {
        for j in 0..<2 {
            wayOld[i][j] += 1
        }
    }
    
    print(wayOld)
    print(price)
    
    way.append(wayOld[0][0])
    way.append(wayOld[0][1])
    
    for row in 1..<wayOld.count {
        way.append(wayOld[row][1])
    }
    
    return way
}

// Поиск минимума в стоке матрицы
func minRow(matrix: [[Double]] = [[],[]], row: Int) -> Double {
    let count = matrix.count
    
    var masMin: [Double] = []
    
    for column in 0..<count {
        if matrix[row][column] != -1 {
            masMin.append(matrix[row][column])
        }
    }
    
    if masMin.min() == nil {
        return 0
    } else {
        return masMin.min()!
    }
}

// Поиск минимума в строке матрицы находящейся на пересечении 0
func minRowZero(matrix: [[Double]] = [[],[]], row: Int, columnFirst: Int) -> Double {
    let count = matrix.count
    
    var masMin: [Double] = []
    
    for column in 0..<count {
        if matrix[row][column] != -1 && column != columnFirst {
            masMin.append(matrix[row][column])
        }
    }
    
    if masMin.min() == nil {
        return 0
    } else {
        return masMin.min()!
    }
}

// Поиск минимума в столбще
func minColumn(matrix: [[Double]] = [[],[]], column: Int) -> Double {
    let count = matrix.count
    
    var masMin: [Double] = []
    
    for row in 0..<count {
        if matrix[row][column] != -1 {
            masMin.append(matrix[row][column])
        }
    }
    
    if masMin.min() == nil {
        return 0
    } else {
        return masMin.min()!
    }
}

// Поиск минимума в столбце матрицы находящейся на пересечении 0
func minColumnZero(matrix: [[Double]] = [[],[]], column: Int, rowFirst: Int) -> Double {
    let count = matrix.count
    var masMin: [Double] = []
    
    for row in 0..<count {
        if matrix[row][column] != -1 && row != rowFirst {
            masMin.append(matrix[row][column])
        }
    }
    if masMin.min() == nil {
        return 0
    } else {
        return masMin.min()!
    }
}

// Поиск пути
func searchCommivoyager(matrix: [[Double]] = [[],[]]) -> [Double] {

    var way: [Double] = []
    var newMatrix = matrix
    
    var indexRow = 0 // индекс строки после которой удалили строку
    var indexCol = 0 // индекс столбца после которого удалили столбец
    
    for iteraciya in 0..<1 { // newMatrix.count-1 {
        
        var arrayMin: [Double] = [] // массив минимальных значений строк / столбцов
        
        let countCity = newMatrix.count
        // Найдем в каждой строке минимальное значение
        for row in 0..<countCity {
            arrayMin.append(minRow(matrix: newMatrix, row: row))
        }
        
        // Произведем редукцию строк
        for row in 0..<countCity {
            for column in 0..<countCity {
                if newMatrix[row][column] != -1 {
                    newMatrix[row][column] -= arrayMin[row]
                }
            }
        }
        
        arrayMin = [] // обнуляем массив минимальных значений
        
        // Найдем минимальное значение в каждом столбце
        for column in 0..<countCity {
            arrayMin.append(minColumn(matrix: newMatrix, column: column))
        }
        
        // Произведем редукцию столбцов
        for column in 0..<newMatrix.count {
            for row in 0..<newMatrix[column].count {
                if newMatrix[row][column] != -1 {
                    newMatrix[row][column] -= arrayMin[column]
                }
            }
        }
        
        // Вычислим для нулевых клеток оценки и найдем максимум
        
        var matrixRatingsZero = newMatrix
        
        var wayN = [Double: [Double]]() // словарь максимальных значений с соответствующим маршрутом
        var wayZ: [Double] = [] // массив цен
        
        for row in 0..<countCity {
            for column in 0..<countCity {
                if newMatrix[row][column] == 0 {
                    let price = minRowZero(matrix: newMatrix, row: row, columnFirst: column) + minColumnZero(matrix: newMatrix, column: column, rowFirst: row)
                    matrixRatingsZero[row][column] = price
                    
                    if !way.contains(Double(column+1)) {
                    
                        wayZ.append(price)
                        wayN[price] = [Double(row+1),Double(column+1)]
                        
                    }
                }
            }
        }

        guard let max = wayZ.max() else {
            break
        }

        //let max = wayZ.max()! // Максимальная оценка
        let znach = wayN[max]! // Найденный оптимальный путь
        
        // формирование массива итогового маршрута
        if znach[0] > Double(indexRow) {
            way.append(znach[0]+Double(iteraciya))
        } else {
            way.append(znach[0])
        }
        
        if znach[1] > Double(indexCol) {
            way.append(znach[1]+Double(iteraciya))
            
        } else {
            way.append(znach[1])
        }
    
        // Ставим символ '-1' в клеткe, которая соответствуют пути замыкающим маршрут раньше времени
        newMatrix[Int(znach[1])-1][Int(znach[0])-1] = -1
        
        // удаление строки
        newMatrix.remove(at: Int(znach[0])-1)
        // удаление столбца
        for row in 0..<newMatrix.count {
            newMatrix[row].remove(at: Int(znach[1])-1)
        }
        
        // обновление индекса удаленных строки и столбца
        indexRow = Int(znach[0])-1
        indexCol = Int(znach[1])-1
        
        print("newMAtrix:")
        for i in 0..<newMatrix.count {
            print(newMatrix[i])
        }
        
//        var ii = 0
//        for i in 1...matrix.count {
//            for j in 1...way.count {
//                if i == Int(way[j-1]) {
//                    ii += 1
//                    break
//                }
//            }
//        }
        
//        print("ii = \(ii)")
//        if ii == countCity {
//            break
//        }
        
    }
    
    //    // удаляем задвоенные города
    //    way.append(way[0])
    //    var element = 1
    //    while element <= way.count-1 {
    //        if way[element-1] == way[element] {
    //            way.remove(at: element)
    //        } else {
    //            element += 1
    //        }
    //
    //    }
    
    print("WAY - \(way)")

    return way
}








