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

// MARK: - Fetch Requests

extension UserInfoMO: ManagedEntity {
    static func hasUserInfo(with id: Int64) -> NSFetchRequest<UserInfoMO> {
        let request = newFetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        return request
    }

    static func allUserInfo() -> NSFetchRequest<UserInfoMO> {
        let request = newFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return request
    }
}

// MARK: - map func

extension UserInfoMO {
    func map(_ userInfo: UserInfo, context: NSManagedObjectContext) {
        self.id = userInfo.id
        self.address = userInfo.address?.store(in: context)
        self.company = userInfo.company?.store(in: context)
        self.email = userInfo.email
        self.name = userInfo.name
        self.phone = userInfo.phone
        self.username = userInfo.username
        self.website = userInfo.website
    }
}

// MARK: - init func

extension UserInfo {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> UserInfoMO {
        let allInfo = try? context.fetch(UserInfoMO.newFetchRequest())
        let userInfoMO = allInfo?.first(where: { $0.id == self.id }) ?? UserInfoMO(context: context)
        userInfoMO.map(self, context: context)
        let postsRequest = FullPostMO.newFetchRequest()
        try? context.fetch(postsRequest).forEach { fullPost in
            if fullPost.userId == self.id {
                fullPost.userInfo = userInfoMO
            }
        }
        return userInfoMO
    }

    init(managedObject: UserInfoMO) {
        self.id = managedObject.id
        self.name = managedObject.name
        self.username = managedObject.username
        self.email = managedObject.email
        self.address = Address(managedObject: managedObject.address)
        self.phone = managedObject.phone
        self.website = managedObject.website
        self.company = Company(managedObject: managedObject.company)
    }
}
