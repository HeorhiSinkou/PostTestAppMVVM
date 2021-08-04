//
//  FullPostMO+Extension.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import Foundation
import CoreData

// MARK: - Fetch Requests

extension FullPostMO: ManagedEntity {
    static func justOnePost() -> NSFetchRequest<FullPostMO> {
        let request = newFetchRequest()
        request.fetchLimit = 1
        return request
    }

    static func posts() -> NSFetchRequest<FullPostMO> {
        let request = newFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return request
    }

    static func post(id: Int64) -> NSFetchRequest<FullPostMO> {
        let request = newFetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        request.fetchLimit = 1
        return request
    }
}

// MARK: - map func

extension FullPostMO {
    func map(_ fullPost: FullPost, context: NSManagedObjectContext) {
        self.id = fullPost.id
        self.body = fullPost.body
        self.title = fullPost.title
        self.userId = fullPost.userId
    }
}

// MARK: - init func

extension FullPost {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> FullPostMO {
        let allPosts = try? context.fetch(FullPostMO.newFetchRequest())
        let fullPostMO = allPosts?.first(where: { $0.id == self.id }) ?? FullPostMO(context: context)
        fullPostMO.map(self, context: context)
        return fullPostMO
    }

    init(managedObject: FullPostMO) {
        self.userId = managedObject.userId
        self.id = managedObject.id
        if let userInfoMO = managedObject.userInfo {
            self.userInfo = UserInfo(managedObject: userInfoMO)
        }
        self.title = managedObject.title
        self.body = managedObject.body
    }
}
