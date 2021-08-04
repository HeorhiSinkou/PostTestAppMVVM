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
