//
//  DataService.swift
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
    private let REF_STORAGE: FIRStorageReference!
    private let REF_SNAPS_STORAGE: FIRStorageReference!
    
    
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
    
    var storageReference: FIRStorageReference {
        return REF_STORAGE
    }
    
    var snapsStorageReference: FIRStorageReference {
        return REF_SNAPS_STORAGE
    }
    
    // MARK: - Class Methods
    init() {
        REF_DATABASE = FIRDatabase.database().reference()
        REF_USERS = REF_DATABASE.child("users")
        REF_SNAPS = REF_DATABASE.child("snaps")
        REF_STORAGE = FIRStorage.storage().reference()
        REF_SNAPS_STORAGE = REF_STORAGE.child("snaps")
    }
}
