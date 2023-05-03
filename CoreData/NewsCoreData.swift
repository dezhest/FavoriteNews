
import Foundation
import CoreData
import UIKit

@objc(NewsCoreData)
public class NewsCoreData: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "NewsCoreData"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}

extension NewsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCoreData> {
        return NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
    }

    @NSManaged public var title: String
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String
    @NSManaged var uiImage: UIImage?

}

extension NewsCoreData: Identifiable {
}



