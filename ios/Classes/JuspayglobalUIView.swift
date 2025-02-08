//
//  JuspayglobalUIView.swift
//  tenantsdkflutter
//
//  Created by Harsh Garg on 10/05/24.
//

import Foundation

class JuspayglobalUIView: UIView {
    private let methodChannel: FlutterMethodChannel?


    init(frame: CGRect, methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        super.init(frame: frame)
        self.tag = getNewTag()
    }

    required init?(coder: NSCoder) {
        self.methodChannel = nil
        super.init(coder: coder)
    }

    override func didMoveToWindow() {
        methodChannel?.invokeMethod("hyperViewCreated", arguments: tag)
    }

    private func getNewTag() -> Int {
        return Int(arc4random_uniform(UInt32.max))
    }
}
