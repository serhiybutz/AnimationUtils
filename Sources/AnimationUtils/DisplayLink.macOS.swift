//
//  DisplayLink.macOS.swift
//  AnimationUtils
//
//  Copyright © Serhiy Butz 2023
//  MIT license, see LICENSE file for details
//

#if os(macOS)

import AppKit
import Foundation
import CoreVideo

final class DisplayLink: DisplayLinkProtocol {

    // MARK: - Properties

    var callback: () -> Void = {}
    private var link: CVDisplayLink?

    // MARK: - Initialization

    deinit {
        guard let link = link else { return }
        CVDisplayLinkStop(link)
    }

    // MARK: - API

    func activate() {
        CVDisplayLinkCreateWithActiveCGDisplays(&link)

        guard let link = link else { return }

        let opaquePointerToSelf = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CVDisplayLinkSetOutputCallback(link, _imageEngineDisplayLinkCallback, opaquePointerToSelf)

        CVDisplayLinkStart(link)
    }

    // MARK: - Helpers

    @objc
    fileprivate func screenDidRender() {
        DispatchQueue.main.async(execute: callback)
    }
}

// swiftlint:disable:next function_parameter_count
private func _imageEngineDisplayLinkCallback(displayLink: CVDisplayLink,
                                             _ now: UnsafePointer<CVTimeStamp>,
                                             _ outputTime: UnsafePointer<CVTimeStamp>,
                                             _ flagsIn: CVOptionFlags,
                                             _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                                             _ displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn {
    unsafeBitCast(displayLinkContext, to: DisplayLink.self).screenDidRender()
    return kCVReturnSuccess
}

#endif
