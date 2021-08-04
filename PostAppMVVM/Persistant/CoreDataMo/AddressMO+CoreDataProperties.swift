//
//  AddressMO+CoreDataProperties.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//
//

import Foundation
import CoreData


extension AddressMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressMO> {
        return NSFetchRequest<AddressMO>(entityName: "AddressMO")
    }

    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var geo: GeoMO?
    @NSManaged public var userInfo: UserInfoMO?

}

extension AddressMO : Identifiable {

}
