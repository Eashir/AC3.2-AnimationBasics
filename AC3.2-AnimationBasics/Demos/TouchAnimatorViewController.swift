//
//  TouchAnimatorViewController.swift
//  AC3.2-AnimationBasics
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 Access Code. All rights reserved.
//

import UIKit
import SnapKit

class TouchAnimatorViewController: UIViewController {
  
  var animator: UIViewPropertyAnimator? = nil
  let squareSize = CGSize(width: 100.0, height: 100.0)
  var viewIsCurrentlyHeld: Bool = false
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewHierarchy()
    configureConstraints()
  }
  
  
  // MARK: - Setup
  private func configureConstraints() {
    darkBlueView.snp.makeConstraints{ view in
      view.center.equalToSuperview()
      view.size.equalTo(squareSize)
    }
  }
  
  private func setupViewHierarchy() {
    self.view.backgroundColor = .white
    self.view.isUserInteractionEnabled = true
    
    view.addSubview(darkBlueView)
  }
  
  
  // MARK: - Movement
  internal func move(view: UIView, to point: CGPoint) {
    if animator!.isRunning {
      animator?.addAnimations {
        self.view.layoutIfNeeded()
      }
    }
    
    view.snp.remakeConstraints { (view) in
      view.center.equalTo(point)
      view.size.equalTo(squareSize)
    }

  }
  
  internal func pickUp(view: UIView) {
    animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: { 
      view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    })

    animator?.startAnimation()
  }
  
  internal func putDown(view: UIView) {
    animator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn, animations: {
      view.transform = CGAffineTransform.identity
    })
    
    animator?.startAnimation()
  }
  
  
  // MARK: - Tracking Touches
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let touchWasInsideOfDarkBlueView = darkBlueView.frame.contains(touch.location(in: view))
    
    if touchWasInsideOfDarkBlueView {
      pickUp(view: darkBlueView)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    putDown(view: darkBlueView)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    move(view: darkBlueView, to: touch.location(in: view))
  }
  
  
  // MARK: - Views
  internal lazy var darkBlueView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = Colors.darkBlue
    return view
  }()
}
