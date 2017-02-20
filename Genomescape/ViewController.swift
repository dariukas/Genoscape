//
//  ViewController.swift
//  Genomescape
//
//  Created by Darius Miliauskas on 2017-02-19.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableTitleLbl: UILabel!
    @IBOutlet weak var dataTableView: UITableView!
    var models = [GenomeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dataTableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: "DataCell")
        updateGenomeList()
        //GenomeMusicPlayer().play()
        GenomeModel().convert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Update TableView
    func updateGenomeList() {
        models = GenomeModel.getList()!
    }
    
    @IBAction func addData(_ sender: Any) {
        alert()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            dataTableView.dequeueReusableCell(withIdentifier: "DataCell")
        cell!.textLabel!.text = models[indexPath.row].name
        return cell!
    }

    func alert() {
        let alert = UIAlertController(title: "Save Genome",
                                      message: "Add a new genome:",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                       let genomeName = alert.textFields!.first!.text
                                       let genomeSequence = alert.textFields![1].text
                                        //validation of genome sequence will be added
                                        GenomeModel().addItem(genomeName!, sequence: genomeSequence!)
                                        self.updateGenomeList()
                                        self.dataTableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
            textField.placeholder = "Genome Title"
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
            textField.placeholder = "Genome Sequence"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }
}

