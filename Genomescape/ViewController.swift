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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Update TableView
    func updateGenomeList() {
        models = GenomeModel.getList()!
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        GenomeMusicPlayer().play(melody: models[sender.tag].notes!)
        if (sender.title(for: .normal)=="Play") {
            sender.setTitle("Stop", for: .normal)
        } else {
            sender.setTitle("Play", for: .normal)
        }
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
        
        cell?.accessoryType = UITableViewCellAccessoryType.detailButton
        cell?.accessoryView = addPlayButton(index: indexPath.row)
        
        return cell!
    }
    
    
    func addPlayButton(index: Int) -> UIButton {
        
        let button:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: Selector("play:"), for: .touchUpInside)
        button.tag = index
        return button
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

