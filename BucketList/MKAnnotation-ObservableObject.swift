//
//  MKAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Dmitry Reshetnik on 19.03.2020.
//  Copyright © 2020 Dmitry Reshetnik. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown subtitle"
        }
        set {
            subtitle = newValue
        }
    }
}
