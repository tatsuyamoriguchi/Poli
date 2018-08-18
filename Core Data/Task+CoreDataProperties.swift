//
//  Task+CoreDataProperties.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 7/30/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isDone: Bool
    @NSManaged public var isImportant: Bool
    @NSManaged public var toDo: String?
    @NSManaged public var goalAssigned: Goal?

}
