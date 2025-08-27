//
// -----------------------------------------
// Original project: SnakeGPT
// Original package: SnakeGPT
// Created on: 04/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

// import SwiftUI
// import AppKit
//
// struct KeyEventHandlingView: NSViewRepresentable {
//    class KeyView: NSView {
//        var onKeyDown: ((NSEvent) -> Void)?
//
//        override var acceptsFirstResponder: Bool { true }
//
//        override func keyDown(with event: NSEvent) {
//            onKeyDown?(event)
//        }
//    }
//
//    var onKeyDown: ((NSEvent) -> Void)
//
//    func makeNSView(context: Context) -> KeyView {
//        let view = KeyView()
//        view.onKeyDown = onKeyDown
//        DispatchQueue.main.async {
//            view.window?.makeFirstResponder(view)
//        }
//        return view
//    }
//
//    func updateNSView(_ nsView: KeyView, context: Context) {}
// }
