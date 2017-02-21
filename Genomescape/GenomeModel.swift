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
    var notes : [(UInt8, Int)]?
    
    class func getList() -> [GenomeModel]? {
        var dataArray: Array<GenomeModel> = [GenomeModel]()
        //        let genome : Genome = [NSManagedObject]()
        if let genomes = fetchData() {
            for genome in genomes {
                let genomeModel = GenomeModel()
                genomeModel.name = (genome.value(forKey: "name") as? String)!
                genomeModel.sequence = (genome.value(forKey: "sequence") as? String)!
                genomeModel.notes = convertingGenomeIntoNotes(genomeModel.sequence!)
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
    
    //pagal moline mase
    // MARK: Genome Sequence to Notes
    class func convertingGenomeIntoNotes(_ sequence0: String) -> [(UInt8, Int)] {
        
        var notes: [(UInt8, Int)] = []
        let items: [(String, String)] = splittingGenomeSequence(sequence0)
        for item in items {
           let note = convertingGenomeTriplet(item, cases: frequencyDublets(sequence0))
           notes.append(note)
        }
        return notes
    }
    
    class func splittingGenomeSequence(_ sequence: String) ->  [(String, String)] {

        var result: [(String, String)] = []
        var a : String = ""
        sequence.uppercased().characters.enumerated().forEach{
            if ($0.offset % 3 == 2) {
                result.append((a, String($0.element)))
                a=""
            } else {
                a += String($0.element)}
        }
        return result
    }
    
    class func convertingGenomeTriplet(_ triplet: (String, String), cases: [String]) -> (UInt8, Int) {
        
        var i : UInt8 = 60
        for case0 in cases {
            if (triplet.0==case0) {
                i += 1
                return (i, nucleotideIntoDuration(triplet.1))
            }
        }
        return (0, 0)
        /*case cases[0]:
            return (1, nucleotideIntoDuration(value))*/
    }
    
    
    class func nucleotideIntoDuration(_ nucleotide:String) -> Int {
        
        switch nucleotide
        {
        case "C":
            return 1
        case "G":
            return 2
        case "T":
            return 3
        case "A":
            return 4
        default:
            return 0
        }
    }
    
    class func frequencyDublets(_ sequence: String) -> [String] {

        let triplets = String(sequence.uppercased().characters.enumerated().map() {
            $0.offset % 3 == 0 ? [$0.element] : [$0.element, ":"]
            }.joined().dropLast()).components(separatedBy: ":")
        let filteredTriplets = triplets.enumerated().filter{$0.offset % 2 == 0}.flatMap{$0.element}
        
        var tripletsFrequenceDic=[String: Int]()
        filteredTriplets.forEach { tripletsFrequenceDic[$0] = (tripletsFrequenceDic[$0] ?? 0) + 1 }
        let tripletsFrequenceDicSorted = tripletsFrequenceDic.sorted(by: { $0.value > $1.value } )
        
        var results=Dictionary<String, Int>()
        for (key, value) in tripletsFrequenceDicSorted {
            results[key]=value
        }
        return Array(results.keys)
    }
    
    
    // MARK: Additional Methods
    enum Nucleotide : Int {
        case C, G, A, T
    }
    
    //the method converts the string of nucleotides to the collection of nucleotide enums
    func genomeSequenceToNucleotideEnum(genomeSequence: String) -> [Nucleotide] {
        
        var dataArray = [Nucleotide]()
        "cgacga".uppercased().characters.forEach{
            
            switch $0 {
            case "C":
                dataArray.append(.C)
            case "G":
                dataArray.append(.G)
            case "A":
                dataArray.append(.A)
            case "T":
                dataArray.append(.T)
            default:
                break
            }
        }
        return dataArray
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
