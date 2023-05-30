//
//  AnimationStatusReporterModifier.swift
//  AnimationUtils
//
//  Copyright © Serhiy Butz 2023
//  MIT license, see LICENSE file for details
//

import SwiftUI

public enum AnimationStatus {
    case started,
         completed
}

extension View {

    public func reportingAnimationStatus<Value: VectorArithmetic>(for value: Value, callback: @escaping (AnimationStatus) -> Void) -> ModifiedContent<Self, AnimationStatusReporterModifier<Value>> {
        modifier(AnimationStatusReporterModifier(targetValue: value, callback: callback))
    }
}

public struct AnimationStatusReporterModifier<Value>: ViewModifier, Animatable where Value: VectorArithmetic {

    public var animatableData: Value
    @StateObject private var manager: Core<Value>

    public init(targetValue: Value, callback: @escaping (AnimationStatus) -> Void) {
        self.animatableData = targetValue
        self._manager = StateObject(wrappedValue: Core<Value>(targetValue: targetValue, callback: callback))
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: animatableData) { newValue in
                manager.animatableData = animatableData
            }
    }
}

fileprivate class Core<Value: VectorArithmetic>: ObservableObject {

    private let callback: (AnimationStatus) -> Void
    private let dLink: DisplayLink = DisplayLink()
    private var animatableDataTrail: [Value] = [.zero, .zero, .zero]
    private var isIdle: Bool = true
    var animatableData: Value

    init(targetValue: Value, callback: @escaping (AnimationStatus) -> Void) {
        self.callback = callback
        self.animatableData = targetValue
        dLink.callback = { [weak self] in
            guard let self else { return }

            self.animatableDataTrail[2] = self.animatableDataTrail[1]
            self.animatableDataTrail[1] = self.animatableDataTrail[0]
            self.animatableDataTrail[0] = self.animatableData

            let isIdle = self.animatableDataTrail[0] == self.animatableDataTrail[1] && self.animatableDataTrail[1] == self.animatableDataTrail[2]

            if !self.isIdle && isIdle {
                Task {
                    self.callback(.completed)
                }
            } else if self.isIdle && !isIdle {
                Task {
                    self.callback(.started)
                }
            }

            self.isIdle = isIdle
        }
        dLink.activate()
    }
}
