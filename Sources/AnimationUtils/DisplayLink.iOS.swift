//
//  DisplayLink.iOS.swift
//  AnimationUtils
//
//  Copyright © Serhiy Butz 2023
//  MIT license, see LICENSE file for details
//

#if os(iOS)

import Foundation
import QuartzCore

final class DisplayLink: DisplayLinkProtocol {

    // MARK: - Properties

    var callback: () -> Void = {}
    private lazy var link = makeLink()

    // MARK: - Initialization

    deinit {
        link.remove(from: .main, forMode: .common)
    }

    // MARK: - API

    func activate() {
        link.add(to: .main, forMode: .common)
    }

    // MARK: - Helpers

    private func makeLink() -> CADisplayLink {
        CADisplayLink(target: self, selector: #selector(screenDidRender))
    }

    @objc
    private func screenDidRender() {
        callback()
    }
}

#endif
