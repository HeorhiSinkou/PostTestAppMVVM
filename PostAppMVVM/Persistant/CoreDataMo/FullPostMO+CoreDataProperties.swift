//
//  FullPostMO+CoreDataProperties.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//
//

import Foundation
import CoreData


extension FullPostMO {

    @nonobjc dynamic public class func fetchRequest() -> NSFetchRequest<FullPostMO> {
        return NSFetchRequest<FullPostMO>(entityName: "FullPostMO")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var userId: Int64
    @NSManaged public var userInfo: UserInfoMO?

}

extension FullPostMO : Identifiable {

}
