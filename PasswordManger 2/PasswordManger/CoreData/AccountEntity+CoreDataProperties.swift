

import Foundation
import CoreData


extension AccountEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountEntity> {
        return NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var appName: String?
    @NSManaged public var mail: String?
    @NSManaged public var password: String?

}
