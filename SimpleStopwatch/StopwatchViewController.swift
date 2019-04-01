//
//  ViewController.swift
//  SimpleTimer
//
//  Created by Ivan De Martino on 3/31/19.
//  Copyright © 2019 Ivan De Martino. All rights reserved.
//

import UIKit

final class StopwatchViewController: UIViewController {

  @IBOutlet weak var timerLabel: UILabel! {
    didSet {
      timerLabel.font = timerLabel.font.monospacedDigitFont
    }
  }
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var startButton: UIButton!

  var milliseconds: TimeInterval = 0
  var timer = Timer()
  var resumeTapped = false

  override func viewDidLoad() {
    super.viewDidLoad()
    pauseButton.isEnabled = false
  }

  @IBAction func start(_ sender: UIButton) {
    runTimer()
    startButton.isEnabled = false
  }

  @IBAction func pause(_ sender: UIButton) {
    toggleResume()
  }

  @IBAction func reset(_ sender: UIButton) {
    timer.invalidate()
    resetTimerLabel()
    pauseButton.setTitle("Pause", for: .normal)
    pauseButton.isEnabled = false
    resumeTapped = false
    startButton.isEnabled = true
  }

  private func runTimer() {
    timer = Timer.scheduledTimer(
      timeInterval: 0.01,
      target: self,
      selector: #selector(updateTimerLabel),
      userInfo: nil,
      repeats: true
    )
    pauseButton.isEnabled = true
  }

  private func toggleResume() {
    if resumeTapped == false {
      timer.invalidate()
      resumeTapped = true
      pauseButton.setTitle("Resume", for: .normal)
    } else {
      runTimer()
      resumeTapped = false
      pauseButton.setTitle("Pause", for: .normal)
    }
  }

  @objc private func updateTimerLabel() {
    milliseconds += 1
    timerLabel.text = timeString(time: milliseconds)
  }

  private func resetTimerLabel() {
    milliseconds = 0
    timerLabel.text = timeString(time: milliseconds)
  }

  private func timeString(time: TimeInterval) -> String {
    let minutes = Int(time) / 6000 % 60
    let seconds = Int(time) / 100 % 60
    let milliseconds = Int(time) % 100
    return String(format: "%02i:%02i:%02i", minutes, seconds, milliseconds)
  }
}

extension UIFont {
  var monospacedDigitFont: UIFont {
    let newFontDescriptor = fontDescriptor.monospacedDigitFontDescriptor
    return UIFont(descriptor: newFontDescriptor, size: 0)
  }
}

private extension UIFontDescriptor {
  var monospacedDigitFontDescriptor: UIFontDescriptor {
    let fontDescriptorFeatureSettings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                                          UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
    let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
    let fontDescriptor = self.addingAttributes(fontDescriptorAttributes)
    return fontDescriptor
  }
}
