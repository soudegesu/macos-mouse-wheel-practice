//
//  View+Mouse.swift
//  macos-mouse-wheel-practice
//
//  Created by soudegesu on 2022/02/18.
//

import SwiftUI

protocol MouseScrollableViewDelegateProtocol {
  func scrollWheel(with event: NSEvent)
}

class MouseScrollableView : NSView {
  
  let modifiers: NSEvent.ModifierFlags?
  
  let cancelBubble: Bool
  
  let perform: (_ event: NSEvent) -> Void

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(modifiers: NSEvent.ModifierFlags?, cancelBubble: Bool, _ perform: @escaping (_ event: NSEvent) -> Void) {
    self.modifiers = modifiers
    self.cancelBubble = cancelBubble
    self.perform = perform
    super.init(frame: NSRect())
  }
  
  override func mouseUp(with event: NSEvent) {
    superview?.mouseUp(with: event)
  }
  
  override func mouseDown(with event: NSEvent) {
    superview?.mouseDown(with: event)
  }
  
  override func mouseMoved(with event: NSEvent) {
    superview?.mouseMoved(with: event)
  }
  
  override func mouseExited(with event: NSEvent) {
    superview?.mouseExited(with: event)
  }
  
  override func mouseDragged(with event: NSEvent) {
    superview?.mouseDragged(with: event)
  }
  
  override func mouseEntered(with event: NSEvent) {
    superview?.mouseEntered(with: event)
  }
  
  override func rightMouseUp(with event: NSEvent) {
    superview?.rightMouseUp(with: event)
  }
  
  override func rightMouseDown(with theEvent: NSEvent) {
    superview?.rightMouseDown(with: theEvent)
  }
  
  override func rightMouseDragged(with event: NSEvent) {
    superview?.rightMouseDragged(with: event)
  }
  
  override func otherMouseUp(with event: NSEvent) {
    superview?.otherMouseUp(with: event)
  }
  
  override func otherMouseDown(with event: NSEvent) {
    superview?.otherMouseDown(with: event)
  }
  
  override func otherMouseDragged(with event: NSEvent) {
    superview?.otherMouseDragged(with: event)
  }
  
  override func scrollWheel(with event: NSEvent) {
    
    if let modifiers = modifiers {
      if event.modifierFlags.contains(modifiers) {
        perform(event)
      }
    } else {
      perform(event)
    }
    if !cancelBubble {
      superview?.scrollWheel(with: event)
    }
  }
}

struct MouseScrollable: NSViewRepresentable {
  
  let modifiers: NSEvent.ModifierFlags?
  let cancelBubble: Bool
  let perform: (_ event: NSEvent) -> Void
  let frame: NSRect
  
  func makeNSView(context: Context) -> NSView {
    let view = MouseScrollableView(modifiers: modifiers, cancelBubble: cancelBubble, perform)
    view.frame = frame
    let options: NSTrackingArea.Options = [
      .mouseMoved,
      .mouseEnteredAndExited,
      .inVisibleRect,
      .activeAlways,
    ]
    let trackingArea = NSTrackingArea(
      rect: frame,
      options: options,
      owner: context.coordinator,
      userInfo: nil
    )
    view.addTrackingArea(trackingArea)
    return view
  }
  
  func updateNSView(_ nsView: NSView, context: Context) {
  }
  
  static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
    nsView.trackingAreas.forEach { nsView.removeTrackingArea($0) }
  }
}

struct MouseWheelModifier: ViewModifier {
  
  var modifiers: NSEvent.ModifierFlags?
  
  var cancelBubble: Bool = false
  
  var perform: (_ event: NSEvent) -> Void
  
  func body(content: Content) -> some View {
    GeometryReader { proxy in
      ZStack {
        content
        MouseScrollable(modifiers: modifiers,
                        cancelBubble: cancelBubble,
                        perform: perform,
                        frame: proxy.frame(in: .global))
      }
    }
  }
}


extension View {

  func onMouseWheel(perform: @escaping (_ event: NSEvent) -> Void) -> some View {
    modifier(MouseWheelModifier(perform: perform))
  }
  
  func onMouseWheel(modifiers: NSEvent.ModifierFlags?, perform: @escaping (_ event: NSEvent) -> Void) -> some View {
    modifier(MouseWheelModifier(modifiers: modifiers, perform: perform))
  }
  
  func onMouseWheel(modifiers: NSEvent.ModifierFlags?, cancelBubble: Bool, perform: @escaping (_ event: NSEvent) -> Void) -> some View {
    modifier(MouseWheelModifier(modifiers: modifiers, cancelBubble: cancelBubble, perform: perform))
  }
}
