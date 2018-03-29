//
//  ViewController.swift
//  TaskSolutionCommivoyagera
//
//  Created by E.Vladimir A. on 05.11.2017.
//  Copyright © 2017 E.Vladimir A. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var historyTable: [History] = [] // ссылка на запись в таблице
    
    @IBOutlet weak var pathOutlet: UILabel!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var citiesPickerView: UIPickerView!
    @IBOutlet weak var calculateButtonOutlet: UIButton!
    
    var countCities = 1
    var cities: [String] = []
    var matrix: [[Double]] = [[]]
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateButtonOutlet.layer.backgroundColor = UIColor.orange.cgColor
        calculateButtonOutlet.layer.cornerRadius = 10
        calculateButtonOutlet.layer.masksToBounds = true
        
        for index in 1...10 {
            cities.append(String(index))
        }
        citiesPickerView.isHidden = false
        citiesPickerView.delegate = self
        citiesPickerView.dataSource = self
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        // Формируем запрос к таблице
        do {
            historyTable = try managedContext.fetch(History.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
        
        //        do {
        //            matrixTable = try managedContext.fetch(Matrix.fetchRequest())
        //        } catch let error as NSError {
        //            print(error)
        //        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countCities = Int(cities[row])!
    }
    
    @IBAction func generateMatrixCities(_ sender: UIBarButtonItem) {
        
        // Очищаем stackView от предыдущей матрицы
        for element in horizontalStackView.subviews {
            element.removeFromSuperview()
        }
        
        // Создание матрицы со случайными значениями
        matrix.removeAll()
        for indexRow in 0...countCities-1 {
            var stroka: [Double] = []
            var random = -1
            for indexCol in 0...countCities-1 {
                if indexRow == indexCol {
                    random = -1
                } else {
                    random = Int(arc4random_uniform(1000))
                    while random == 0 {
                        random = Int(arc4random_uniform(1000))
                    }
                }
                stroka.append(Double(random))
            }
            matrix.append(stroka)
        }
        
        // отображение матрицы на экране
        for indexColumn in 1...countCities+1 {
            var labelsRow: [UILabel] = []
            for indexRow in 1...countCities+1 {
                let id = Int("\(indexRow)\(indexColumn)")!
                let label = UILabel()
                
                if indexColumn == 1 && indexRow == 1 {
                    label.text = "Город"
                    label.layer.backgroundColor = UIColor.orange.cgColor
                } else if indexColumn == 1 {
                    label.text = "\(indexRow-1)"
                    label.layer.backgroundColor = UIColor.orange.cgColor
                } else if indexRow == 1 {
                    label.text = "\(indexColumn-1)"
                    label.layer.backgroundColor = UIColor.orange.cgColor
                } else if Int(matrix[indexRow-2][indexColumn-2]) == -1 {
                    label.text = "M"
                    label.layer.backgroundColor = UIColor.yellow.cgColor
                } else {
                    label.text = String(Int(matrix[indexRow-2][indexColumn-2]))
                    label.layer.backgroundColor = UIColor.white.cgColor
                }
                
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.black.cgColor
                label.layer.cornerRadius = 5
                label.layer.masksToBounds = true
                
                label.adjustsFontSizeToFitWidth = true
                label.widthAnchor.constraint(equalToConstant: CGFloat(24)).isActive = true
                label.heightAnchor.constraint(equalToConstant: CGFloat(24)).isActive = true
                label.textAlignment = .center
                
                label.tag = id
                labelsRow.append(label)
            }
            
            let verticalStackView = UIStackView(arrangedSubviews: labelsRow)
            verticalStackView.axis = .vertical
            verticalStackView.distribution = .equalCentering
            verticalStackView.alignment = .center
            verticalStackView.spacing = 2
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.horizontalStackView.addArrangedSubview(verticalStackView)
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            
        }
        
    }
    
    @IBAction func calculateButtonAction(_ sender: UIButton) {
        var pathString = ""
        var path: [Double] = []
        if countCities != matrix.count {
            
            let ac = UIAlertController(title: "Ошибка", message: "Матрица не соответствует выбранному количеству городов, обновите матрицу", preferredStyle: .alert)
            let aAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(aAction)
            present(ac, animated: true)
            
        } else {
            if countCities == 1 {
                pathString = "Пути нет так как задан 1 город"
            } else if countCities == 2 {
                if matrix[0][1] > matrix[1][0] {
                    pathString = "Дешевый путь:  1 -> 2 -> 1"
                    path.append(1.0)
                    path.append(2.0)
                    path.append(1.0)
                } else {
                    pathString = "Дешевый путь:  2 -> 1 -> 2"
                    path.append(2.0)
                    path.append(1.0)
                    path.append(2.0)
                }
            } else {
                path = searchWayGadnii(matrix: matrix)
                pathString = "Дешевый путь:  \(Int(path[0]))"
                
                for i in 1...path.count-1 {
                    pathString += " -> \(Int(path[i]))"
                }
                
                for index in 0..<path.count-1 {

                    let pathLocal = "\(Int(path[index])+1)\(Int(path[index+1])+1)"
                   
                    let tag = Int(pathLocal)!

                    if let element = horizontalStackView.viewWithTag(tag) {
                        let label = element as! UILabel
                        let color = CGFloat(Double(path.count-2-index) * 0.05)
                        let green = color //((index + 4) * 15)
                        let red = color //((index + 3) * 13)
                        let blue = color //((index + 2) * 11)
                        
                        label.textColor = UIColor.white
                        label.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
                    }
                }
                view.layoutIfNeeded()
            }
            pathOutlet.text = pathString
            
            // Сохранение в базу данных
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            // Получаем контекст
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // Создаем пустую запись, но она еще не сохранена
            let history = History(entity: History.entity(), insertInto: managedContext)
            
            // Устанавливаем значение
            
            history.date = Date()
            history.path = pathString
            history.cityCount = Int16(matrix.count)
            history.matrix = matrix as NSObject
            
            // Сохраняем изменения, сделанные в контексте
            do {
                try managedContext.save()
                historyTable.append(history)
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    @IBAction func unwindToProfileView(sender: UIStoryboardSegue) {
    }
    
}

