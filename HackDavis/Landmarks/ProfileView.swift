//
//  ProfileView.swift
//  HackDavis
//
//  Created by Akshitha Rajendran on 4/20/25.
//
import SwiftUI

class UserData: ObservableObject {
    @Published var name = ""
    @Published var age = ""
    @Published var country = ""
    @Published var visaType = ""
    @Published var help = ""
}

