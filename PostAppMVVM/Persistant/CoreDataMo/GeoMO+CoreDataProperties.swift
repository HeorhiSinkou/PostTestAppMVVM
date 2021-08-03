//
//  GeoMO+CoreDataProperties.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//
//

import Foundation
import CoreData


extension GeoMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeoMO> {
        return NSFetchRequest<GeoMO>(entityName: "GeoMO")
    }

    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var adress: AddressMO?

}

extension GeoMO : Identifiable {

}

// MARK: - map func

extension GeoMO: ManagedEntity {
    func map(_ geo: Geo?) {
        self.lat = geo?.lat
        self.lng = geo?.lng
    }
}

// MARK: - init func

extension Geo {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> GeoMO? {
        guard let geo = GeoMO.insertNew(in: context)
            else { return nil }
        geo.map(self)
        return geo
    }

    init?(managedObject: GeoMO?) {
        guard
            let object = managedObject
        else {
            return nil
        }
        self.lat = object.lat
        self.lng = object.lng
    }
}

