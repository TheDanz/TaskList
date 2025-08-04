//
//  TaskModel+CoreDataProperties.swift
//  TaskList
//
//  Created by Danil Ryumin on 04.08.2025.
//
//

import Foundation
import CoreData

extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var depiction: String
    @NSManaged public var creationDate: Date
    @NSManaged public var isDone: Bool
}

extension TaskModel : Identifiable {

}
