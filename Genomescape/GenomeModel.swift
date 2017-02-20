//
//  Genome.swift
//  Genomescape
//
//  Created by Darius Miliauskas on 2017-02-19.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import CoreData

class GenomeModel: NSObject {
    
    var name : String?
    var sequence : String?
    
    class func getList() -> [GenomeModel]? {
        var dataArray: Array<GenomeModel> = [GenomeModel]()
        //        let genome : Genome = [NSManagedObject]()
        if let genomes = fetchData() {
            for genome in genomes {
                let genomeModel = GenomeModel()
                genomeModel.name = (genome.value(forKey: "name") as? String)!
                genomeModel.sequence = (genome.value(forKey: "sequence") as? String)!
                dataArray.append(genomeModel)
            }
        }
        return dataArray
    }
    
    class func fetchData() -> [Genome]? {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Genome")
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            return results as? [Genome]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func addItem(_ name: String, sequence : String) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "Genome",
                                                 in:managedContext)
        let genome = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        genome.setValue(name, forKey: "name")
        genome.setValue(sequence, forKey: "sequence")
        
        do {
            try managedContext.save()
            //genome.append(genome)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    enum Nucleotide : Int {
        case C, G, A, T
    }
    
    func genomeSequenceToNucleotideEnum(genomeSequence: String) -> [Nucleotide] {

        var dataArray = [Nucleotide]()
        "cgacga".uppercased().characters.forEach{
        
            switch $0 {
            case "C":
                dataArray.append(.C)
            default:
                true
            }
        }
        return dataArray
    }
    
    //pagal moline mase
    func convert() {
        
        let s : String = "cgacga".uppercased()
        
        let characters = s.characters
        
        var notes: [(name: String, value: String)] = []
        var a : String = ""
        s.characters.enumerated().forEach{
            if ($0.offset % 3 == 2) {
                notes.append((a, String($0.element)))
                a=""
            } else {
                a += String($0.element)}
        }
        
        print(notes)
        
        
        /*var dataArray: Array<Nucleotide> = [Nucleotide]()
        
        for character in characters {
            switch character {
            case "C":
                dataArray.append(.C)
            default:
                true
            }
            
        }*/
    }
    
    
    func triples() {
        var s : String = "gcacgagcaaasaasaas"
        s = s.uppercased()
        let triplets = String(s.characters.enumerated().map() {
            $0.offset % 3 == 0 ? [$0.element] : [$0.element, ":"]
            }.joined().dropLast()).components(separatedBy: ":")
        let filteredTriplets = triplets.enumerated().filter{$0.offset % 2 == 0}.flatMap{$0.element}
        
        var tripletsFrequenceDic = [String: Int]()
        filteredTriplets.forEach { tripletsFrequenceDic[$0] = (tripletsFrequenceDic[$0] ?? 0) + 1 }
        let tripletsFrequenceDicSorted = tripletsFrequenceDic.sorted(by: { $0.value > $1.value } )
        
        print(tripletsFrequenceDicSorted)
    }
    
        /*class func getList(_ completion:@escaping (_ success : Bool, _ message : String?, _ models : [AppointmentBillingModel]?) -> Void) {
     Requests.alamofireRequest(.get, api: getCPTCodesApi+"\(AppointmentModel.sharedModel.id!)", parameters: nil, headers: ["RoleId" : "\(RoleModel.sharedModel.id!)", "StaffId" : "\(StaffModel.sharedModel.id!)", "Token" : Utils.getToken()]) {
     (success : Bool, JSON : AnyObject?, errorMessage : String?, count : Int?) in
     if success {
     completion(true, errorMessage, self.parseModel(JSON as! NSArray))
     } else {
     completion(false, errorMessage, nil)
     }
     }
     }*/
    
}
