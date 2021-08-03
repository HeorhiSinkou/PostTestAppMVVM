//
//  CompanyMO+CoreDataProperties.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//
//

import Foundation
import CoreData


extension CompanyMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyMO> {
        return NSFetchRequest<CompanyMO>(entityName: "CompanyMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var bs: String?
    @NSManaged public var userInfo: UserInfoMO?

}

extension CompanyMO : Identifiable {

}

// MARK: - map func

extension CompanyMO: ManagedEntity {
    func map(_ company: Company?) {
        guard
            let company = company
        else {
            return
        }
        self.bs = company.bs
        self.catchPhrase = company.catchPhrase
        self.name = company.name
    }
}

// MARK: - init func

extension Company {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> CompanyMO? {
        guard let company = CompanyMO.insertNew(in: context)
            else { return nil }
        company.map(self)
        return company
    }

    init?(managedObject: CompanyMO?) {
        guard
            let object = managedObject
        else {
            return nil
        }
        self.name = object.name ?? ""
        self.catchPhrase = object.catchPhrase ?? ""
        self.bs = object.bs ?? ""
    }
}
