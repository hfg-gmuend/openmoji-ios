//
//  AboutView.swift
//  OpenMoji
//
//  Created by Sam Eckert on 29.03.24.
//  Copyright © 2024 OpenMoji. All rights reserved.
//

import SwiftUI
import SafariServices

struct AboutView: View {
    @State private var showingSafariAboutView = false
    @State private var showingSafariLicenseView = false
    @State private var safariURL: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("OpenMoji")
                    .font(.custom("SourceSansPro-Regular", size: 25))
                    .fontWeight(.bold)
                
                Text("Project Intent")
                    .font(.custom("SourceSansPro-Regular", size: 20))
                
                Text("Emoji are indispensable for daily communication. They are practical, funny, and sometimes quite bizarre. For us, emoji are much more than colorful images decorating fun short messages. We think they are rather part of an important and exciting development: the return of pictorial symbols to written communication. For the first time in history, it is possible to communicate with a combination of letters and icons. Now it becomes feasible to say things and convey meanings that were previously impossible.\n\nUnfortunately, the creative variety of emoji has been rather limited so far. That is why we have developed OpenMoji as the first open source and independent emoji system to date. OpenMoji is an open-source project of 50+ students and 2 professors of HfG Schwäbisch Gmünd (Design University) and external contributors.")
                    .padding(.bottom)
                    .font(.custom("SourceSansPro-Regular", size: 17))
                
               
  
                
                HStack {
                    Button(action: {
                        showingSafariAboutView = true
                    }, label: {
                        Text("OpenMoji.org")
                            .font(.custom("SourceSansPro-Regular", size: 18))
                            .foregroundColor(Color("actionBlue"))
                            
                    }).sheet(isPresented: $showingSafariAboutView) {
                        SafariAboutView(url: URL(string: "https://OpenMoji.org/about")!)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingSafariLicenseView = true
                    }, label: {
                        Text("CC BY-SA 4.0 License")
                            .font(.custom("SourceSansPro-Regular", size: 18))
                            .foregroundColor(Color("actionBlue"))
                            
                    }).sheet(isPresented: $showingSafariLicenseView) {
                        SafariLicenseView(url: URL(string: "https://creativecommons.org/licenses/by-sa/4.0/")!)
                    }
                }
                
                Spacer(minLength: 20)

                HStack {
                    Spacer()
                    Image("stickers/1F64B", bundle: nil) // Replace "yourImageName" with your image name
                        .resizable()
                        .scaledToFit() // or .scaledToFill() depending on your needs
                        .frame(width: 100)
                    Spacer()
                }
                
                Spacer(minLength: 5)
                
                HStack {
                    Spacer()
                    Text("Built with")
                    
                    Image("stickers/2764", bundle: nil) // Replace "yourImageName" with your image name
                        .resizable()
                        .scaledToFit() // or .scaledToFill() depending on your needs
                        .frame(width: 20)
                    
                    Text("in the open")
                    
                    Spacer()
                }
            }
            .padding()
        }
        .navigationTitle("About OpenMoji")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SafariAboutView: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Here you can update the controller if needed.
    }
}


struct SafariLicenseView: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Here you can update the controller if needed.
    }
}


#Preview {
    AboutView()
}
