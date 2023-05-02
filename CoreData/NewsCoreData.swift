
import Foundation
import CoreData

@objc(NewsCoreData)
public class NewsCoreData: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "News"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}

extension NewsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCoreData> {
        return NSFetchRequest<NewsCoreData>(entityName: "News")
    }

    @NSManaged public var title: String
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String


}

extension NewsCoreData: Identifiable {
}


