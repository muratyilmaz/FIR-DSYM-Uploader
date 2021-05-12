//
//  ProjectItem.swift
//  DSYM-Uploder
//
//  Created by Murat Yilmaz on 12.05.2021.
//

import Foundation

struct ProjectItem: Identifiable {
    var id = UUID()
    var name: String
    var url: URL?
}
