//
//  UserInfoMO+CoreDataProperties.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//
//

import Foundation
import CoreData


extension UserInfoMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfoMO> {
        return NSFetchRequest<UserInfoMO>(entityName: "UserInfoMO")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var username: String?
    @NSManaged public var website: String?
    @NSManaged public var address: AddressMO?
    @NSManaged public var company: CompanyMO?
    @NSManaged public var fullPost: NSSet?

}

// MARK: Generated accessors for fullPost
extension UserInfoMO {

    @objc(addFullPostObject:)
    @NSManaged public func addToFullPost(_ value: FullPostMO)

    @objc(removeFullPostObject:)
    @NSManaged public func removeFromFullPost(_ value: FullPostMO)

    @objc(addFullPost:)
    @NSManaged public func addToFullPost(_ values: NSSet)

    @objc(removeFullPost:)
    @NSManaged public func removeFromFullPost(_ values: NSSet)

}

extension UserInfoMO : Identifiable {

}
