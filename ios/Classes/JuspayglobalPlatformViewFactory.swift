//
//  JuspayglobalPlatformViewFactory.swift
//  hypersdkflutter
//
//  Created by Harsh Garg on 09/05/24.
//

import UIKit
import Flutter

public class JuspayglobalPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    private let binaryMessenger: FlutterBinaryMessenger

    public init(messenger: FlutterBinaryMessenger) {
        binaryMessenger = messenger
        super.init()
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        return JuspayglobalPlatformView(viewId: viewId, messenger: binaryMessenger, frame: frame)
    }
}
