# AnimationUtils

This repo contains a *universal* solution for reporting *SwiftUI* animation status (*started*, *finished*) using the method of checking the trail of 3 adjacent keyframes, which works with *spring* animations. (The repo is planned to be being extended in the future.)

While the lowest platforms this method works on are *iOS 14* and *MacOS 12*, I decided to stick to the most recent versions of them since this repo is more of a lab work on functionality that is still evolving, rather than being a stable library repo.

There's also an article for this method [SwiftUI Spring Animation Completion Tracker](https://serhiybutz.medium.com/swiftui-spring-animation-completion-tracker-fd2a130ff01).

An iOS app demonstrating the use of this view modifier: [AnimationStatusReporterDemo](https://github.com/serhiybutz/AnimationStatusReporterDemo).
