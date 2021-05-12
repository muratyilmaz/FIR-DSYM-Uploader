//
//  ProjectListItem.swift
//  DSYM-Uploder
//
//  Created by Murat Yilmaz on 12.05.2021.
//

import SwiftUI

struct ProjectItemView: View {
    
    let item: ProjectItem
    
    var body: some View {
       
        HStack {
            
            Image(systemName: "calendar")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(item.name)
                Text(item.url?.relativePath ?? "-")
            })
            .font(.caption)
        }
        .padding(10)
       
    }
}

struct ProjectItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectItemView(item: ProjectItem(name: "Bring"))
            
    }
}
