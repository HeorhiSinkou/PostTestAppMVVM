//
//  AddressMO+Extension.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import Foundation
import CoreData

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
