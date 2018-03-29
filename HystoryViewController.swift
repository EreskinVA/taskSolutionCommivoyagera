//
//  HystoryViewController.swift
//  TaskSolutionCommivoyagera
//
//  Created by E.Vladimir A. on 05.11.2017.
//  Copyright © 2017 E.Vladimir A. All rights reserved.
//

import UIKit
import CoreData

class HystoryViewController: UIViewController {
    
    var historyTable: [History] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pathOutlet: UILabel!
    @IBOutlet weak var horizontalStackViewOutlet: UIStackView!
    
    var matrixArray: [History] = []
    
    // загрузка данных из CoreData в массив
    func loadArrayFromCoreData() {
        matrixArray.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            historyTable = try managedContext.fetch(History.fetchRequest())
        } catch let error as NSError {
            print(error)
        }
        
        for row in historyTable {
            matrixArray.append(row)
        }
        
        tableView.reloadData()
    }
    
    // очищаем экран
    func clearView() {
        // Очищаем stackView от предыдущей матрицы
        for element in horizontalStackViewOutlet.subviews {
            element.removeFromSuperview()
        }
        pathOutlet.text = "Дешевый путь:"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadArrayFromCoreData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadArrayFromCoreData()
        clearView()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func clearHistoryCoreData(_ sender: UIBarButtonItem) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            for row in historyTable {
                managedContext.delete(row)
            }
            // historyTable.removeAll()
            self.matrixArray.removeAll()
            
            tableView.reloadData()
        } catch let error as NSError {
            print(error)
        }
        clearView() 
    }
}

extension HystoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matrixArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        cell.dateOutlet.text = "\(matrixArray[indexPath.row].date!)"
        cell.cityCount.text = "\(matrixArray[indexPath.row].cityCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Очищаем stackView от предыдущей матрицы
        for element in horizontalStackViewOutlet.subviews {
            element.removeFromSuperview()
        }
        
        let history = matrixArray[indexPath.row]
        pathOutlet.text = history.path
        
        let matrixNSAr = matrixArray[indexPath.row].matrix as! NSArray
        let matrixAr = matrixNSAr as! Array<[Int]>
        
        
        for indexColumn in 1...matrixAr.count+1 {
            var labelsRow: [UILabel] = []
            for indexRow in 1...matrixAr.count+1 {
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
                } else if Int(matrixAr[indexRow-2][indexColumn-2]) == -1 {
                    label.text = "M"
                    label.layer.backgroundColor = UIColor.yellow.cgColor
                } else {
                    label.text = String(Int(matrixAr[indexRow-2][indexColumn-2]))
                    label.layer.backgroundColor = UIColor.white.cgColor
                }
                
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.black.cgColor
                
                label.layer.cornerRadius = 5
                label.layer.masksToBounds = true
                
                label.adjustsFontSizeToFitWidth = true
                label.widthAnchor.constraint(equalToConstant: CGFloat(22)).isActive = true
                label.heightAnchor.constraint(equalToConstant: CGFloat(22)).isActive = true
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
                self.horizontalStackViewOutlet.addArrangedSubview(verticalStackView)
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            
        }
        var pathArray: [Int] = []
        
        var preSim: Character = " "
        for sim in history.path!.characters {
            if let simInt = Int(String(sim)) {
                if let preSimInt = Int(String(preSim)) {
                    let str = "\(preSim)\(simInt)"
                    pathArray.append(Int(str)!)
                } else {
                   pathArray.append(simInt)
                }
            }
            preSim = sim
        }

        
        for index in 0..<pathArray.count-1 {
            
            let pathLocal = "\(pathArray[index]+1)\(pathArray[index+1]+1)"
            
            let tag = Int(pathLocal)!
            
            if let element = horizontalStackViewOutlet.viewWithTag(tag) {
                let label = element as! UILabel
                let color = CGFloat(Double(pathArray.count-2-index) * 0.05)
                let green = color //((index + 4) * 15)
                let red = color //((index + 3) * 13)
                let blue = color //((index + 2) * 11)
                
                label.textColor = UIColor.white
                label.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            }
        }
        view.layoutIfNeeded()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let deleteItem = historyTable[indexPath.row]
            managedContext.delete(deleteItem)
            
            do {
                try managedContext.save()
                self.matrixArray.remove(at: indexPath.row)
                tableView.reloadData()
            } catch let error as NSError {
                print(error)
            }
            
        }
        
    }
    
}


