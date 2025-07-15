//
//  MyPetDemoApp.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct MyPetDemoApp: App {
  let store = Store(initialState: MyPetReducer.State(), reducer: {
    MyPetReducer()
  })

  var body: some Scene {
    WindowGroup {
      MyPetView(store: store)
    }
  }
}


