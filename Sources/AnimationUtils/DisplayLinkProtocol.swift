//
//  DisplayLinkProtocol.swift
//  AnimationUtils
//
//  Copyright © Serhiy Butz 2023
//  MIT license, see LICENSE file for details
//

import Foundation

protocol DisplayLinkProtocol: AnyObject {
    var callback: () -> Void { get set }
    func activate()
}
