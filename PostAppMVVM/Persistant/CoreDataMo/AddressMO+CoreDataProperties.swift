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

// MARK: - map func

extension AddressMO: ManagedEntity {
    func map(_ address: Address?, context: NSManagedObjectContext) {
        self.city = address?.city
        self.geo = address?.geo?.store(in: context)
        self.street = address?.street
        self.suite = address?.suite
        self.zipcode = address?.zipcode
    }
}

// MARK: - init func

extension Address {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> AddressMO? {
        guard let address = AddressMO.insertNew(in: context)
            else { return nil }
        address.map(self, context: context)
        return address
    }

    init?(managedObject: AddressMO?) {
        guard
            let object = managedObject
        else {
            return nil
        }
        self.city = object.city
        self.geo = Geo(managedObject: object.geo)
        self.street = object.street
        self.suite = object.suite
        self.zipcode = object.zipcode
    }
}
