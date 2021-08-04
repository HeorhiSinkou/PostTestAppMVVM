//
//  UserInfoMO+Extension.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import Foundation
import CoreData

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
