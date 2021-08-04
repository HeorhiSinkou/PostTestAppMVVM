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
