//
//  MyAnnotation.swift
//  SearchMap1
//
//  Created by 赵晓东 on 16/5/13.
//  Copyright © 2016年 ZXD. All rights reserved.
//

import Foundation
import MapKit
class MyAnnotation: NSObject,MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
