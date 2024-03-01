//
//  Model.swift
//  Login
//
//  Created by Droadmin on 12/09/23.
//

import Foundation
class JsonModel{
    var title: String?
    var year: String?
    var image: String?
    
    init(title: String? = nil, year: String? = nil, image: String? = nil) {
        self.title = title
        self.year = year
        self.image = image
    }
    
}
