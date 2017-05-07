//
//  DataSource.swift
//  SnappySnap
//
//  Created by Isomi on 4/27/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import Foundation
import Firebase

public class DataService {
    
    // MARK: - Class Properties
    private static let _shared = DataService()
    private let REF_DATABASE: FIRDatabaseReference!
    private let REF_USERS: FIRDatabaseReference!
    private let REF_SNAPS: FIRDatabaseReference!
    
    public static var shared: DataService {
        return _shared
    }
    
    var databaseReference: FIRDatabaseReference {
        return REF_DATABASE
    }
    
    var usersReference: FIRDatabaseReference {
        return REF_USERS
    }
    
    var snapsReference: FIRDatabaseReference {
        return REF_SNAPS
    }
    
    // MARK: - Class Methods
    init() {
        REF_DATABASE = FIRDatabase.database().reference()
        REF_USERS = REF_DATABASE.child("users")
        REF_SNAPS = REF_DATABASE.child("snaps")
    }
    
    func listUsers() -> [String] {
        var users = [String]()
        DataService.shared.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    users.append(snap.key)
                }
            }
        })
        
        print("DONKEY: Users \(users.debugDescription)")
        return users
    }
}
