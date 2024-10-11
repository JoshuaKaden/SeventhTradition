//
//  MeetingView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/11/24.
//

import SwiftUI

struct MeetingView: View {
    
    @Binding var meeting: Meeting?
    
    var body: some View {
        VStack {
            if let meeting {
                Text("Name")
                    .font(.footnote)
                Text(meeting.name)
                    .padding(.bottom)
                
                Text("Meeting ID")
                    .font(.footnote)
                Text(meeting.id.uuidString)
                    .font(.footnote)                
            }
        }
    }
}
