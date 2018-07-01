//
//  Generated+CoreDataProperties.swift
//  DreamLister_3
//
//  Created by vriz on 2018. 7. 1..
//  Copyright © 2018년 vriz. All rights reserved.
//
//

import Foundation
import CoreData


extension Generated {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Generated> {
        return NSFetchRequest<Generated>(entityName: "Generated")
    }

    @NSManaged public var isGenerated: Bool

}
