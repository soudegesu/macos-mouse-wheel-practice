//
//  ContentView.swift
//  macos-mouse-wheel-practice
//
//  Created by soudegesu on 2022/02/18.
//

import SwiftUI

struct ContentView: View {

  @State var isScrolling: Bool = false

  @ViewBuilder var body: some View {
    VStack(spacing: 8) {
      Text("Cmd key + Mouse wheel here")
      VStack {
        if isScrolling {
          Text("Scrolling now...")
            .font(.body)
        }
      }
      .frame(height: 30)
    }
    .frame(maxWidth: .infinity,
           maxHeight: .infinity)
    .background(Color.gray.opacity(0.5))
    .onMouseWheel(modifiers: .command, cancelBubble: true) { event in
      switch event.phase {
      case .began, .mayBegin:
        isScrolling = true
      case .ended, .cancelled:
        isScrolling = false
      default:
        break
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
