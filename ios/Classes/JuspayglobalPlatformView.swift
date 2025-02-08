//
//  JuspayglobalPlatformView.swift
//  tesntsdkflutter
//
//  Created by Harsh Garg on 09/05/24.
//

import Flutter
import UIKit


class JuspayglobalPlatformView: NSObject, FlutterPlatformView {
    private let _view: UIView

    init(viewId: Int64, messenger: FlutterBinaryMessenger, frame: CGRect) {
        let methodChannel = FlutterMethodChannel(name: "hyper_view_\(viewId)", binaryMessenger: messenger)
        _view = JuspayglobalUIView(frame: frame, methodChannel: methodChannel)
        super.init()
    }

    func view() -> UIView {
        return _view
    }
}
