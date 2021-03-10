//
//  HistoryService.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 5/03/21.
//

import Foundation
import Cocoa
import RealmSwift


class HistoryRecord: Object, Identifiable {
    
    @objc dynamic var id: String!
    @objc dynamic var date: Date!
    @objc dynamic var text: String = ""
    @objc dynamic var imageBase64 = Data()
    
    required init() {
        date = Date()
        id = date.description
        
        text = "loree a asdasda  "
    }
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
}


class HistoryService {
    
    
    private static var configuration: Realm.Configuration = {
        
       let url = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/app.realm")
        
        return Realm.Configuration(fileURL: URL(fileURLWithPath: url),
                                   encryptionKey: nil,
                                   schemaVersion: 17,
                                   deleteRealmIfMigrationNeeded: true)
        
       
    }()

    public static var realm: Realm = {
        let realm = try! Realm(configuration: configuration)
        return realm
    }()
    
    static func add(_ item: HistoryRecord) {
        print( configuration.fileURL)
        
        if let data = configuration.encryptionKey {
            let key = String(data: data, encoding: .utf8)
            print( key)
        }
     
        try! realm.write {
            realm.add(item, update: .all)
        }
    }
    
    static func findAll() -> Array<HistoryRecord>{
        Array(realm.objects(HistoryRecord.self))
    }
    
    static func remove(_ item: HistoryRecord) {
        try! realm.write {
            guard let local = realm.object(ofType: HistoryRecord.self, forPrimaryKey: item.id) else { return }
            realm.delete(local)
        }
    }

    
}
