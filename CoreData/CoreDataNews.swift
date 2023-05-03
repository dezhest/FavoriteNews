//
//  CoreDataNews.swift
//  NewsApi
//
//  Created by Denis Zhesterev on 03.05.2023.
//

import Foundation
import CoreData

@objc(News)
//public class News: NSManagedObject {
//    convenience init() {
//        self.init(entity: CoreDataManager.instance.entityForName(entityName: "News"), insertInto: CoreDataManager.instance.managedObjectContext)
//    }
//}

extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var power: Double
    @NSManaged public var imageD: Data?
    @NSManaged public var title: String
    @NSManaged public var selectedDate: Date
    @NSManaged public var type: String
    @NSManaged public var typeArray: String
    @NSManaged public var scamDescription: String

}

extension News: Identifiable {
}

