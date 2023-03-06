//
//  DataModel.swift
//  CHECKLISTS
//
//  Created by Aisha Nurgaliyeva on 01.03.2023.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
      loadChecklists()
      registerDefaults()
        handleFirstTime()
    }
    
//    print("Documents folder is \(documentsDirectory())")
//    print("Data file path is \(dataFilePath())")
    
    func registerDefaults() {
      let dictionary = [
        "ChecklistIndex": -1,
        "FirstTime": true
      ] as [String: Any]
      UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
      get {
        return UserDefaults.standard.integer(
          forKey: "ChecklistIndex")
    } set {
        UserDefaults.standard.set(
          newValue,
          forKey: "ChecklistIndex")
        }
    }
    
    func handleFirstTime() {
      let userDefaults = UserDefaults.standard
      let firstTime = userDefaults.bool(forKey: "FirstTime")
      if firstTime {
        let checklist = Checklist(name: "List")
        lists.append(checklist)
        indexOfSelectedChecklist = 0
        userDefaults.set(false, forKey: "FirstTime")
      }
    }
    
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    // MARK: - Data Saving

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return
        documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    func saveChecklists() {
        // 1
        let encoder = PropertyListEncoder()
        // 2
        do {
            // 3
            let data = try encoder.encode(lists)
            // 4
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
            // 5
        } catch { // 6
            print("Error encoding item array: \(error.localizedDescription)")
        } }

    func loadChecklists() {
        // 1
        let path = dataFilePath()
        // 2
        if let data = try? Data(contentsOf: path) {
            // 3
            let decoder = PropertyListDecoder()
            do {
                // 4
                lists = try decoder.decode([Checklist].self,from: data)
                sortChecklists()
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
