//
//  ViewController.swift
//  Page View
//
//  Created by MAC on 19/11/19.
//  Copyright © 2019 frzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstButton: UIButton! {
        didSet {
            firstButton.tag = 0
            firstButton.addTarget(self, action: #selector(changePage(button:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var secondButton: UIButton! {
        didSet {
            secondButton.tag = 1
            secondButton.addTarget(self, action: #selector(changePage(button:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var selectorViewLeadingConstraint: NSLayoutConstraint!
    
    var pageController: UIPageViewController!
    var viewControllers = [UIViewController]()
    var currentIndex: Int = 0

    lazy var firstChild: ChildViewController = {
        let viewController = storyboard?.instantiateViewController(identifier: "ChildViewController") as! ChildViewController
        viewController.number = 0
        return viewController
    }()
    
    lazy var secondChild: ChildViewController = {
        let viewController = storyboard?.instantiateViewController(identifier: "ChildViewController") as! ChildViewController
        viewController.number = 1
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageController()
    }
    
    private func configurePageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        pageController.view.frame = self.containerView.bounds
        
        viewControllers = [firstChild, secondChild]
        
        addChild(pageController)
        containerView.addSubview(pageController.view)
        
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        pageController.didMove(toParent: self)
    }
    
    @objc func changePage(button: UIButton) {
        print("tap \(button.tag)")
        setViewController(index: button.tag)
    }
    
    fileprivate func setViewController(index: Int){
        guard currentIndex != index else { return }
        if currentIndex < index {
            pageController.setViewControllers([viewControllers[index]], direction: .forward, animated: true, completion: nil)
        } else {
            pageController.setViewControllers([viewControllers[index]], direction: .reverse, animated: true, completion: nil)
        }
        currentIndex = index
        moveSelectorView(index: index)
    }
    
    fileprivate func moveSelectorView(index: Int) {
        UIView.animate(withDuration: 0.3) {
            self.selectorViewLeadingConstraint.constant = CGFloat(integerLiteral: index) * self.firstButton.bounds.width
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController) {
            if index > 0 {
                return viewControllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController) {
            if index < viewControllers.count - 1 {
                return viewControllers[index + 1]
            } else {
                return nil
            }
        }

        return nil
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
                
        guard completed, let index = viewControllers.firstIndex(where: {$0 == pageViewController.viewControllers?.first}) else { return }
        currentIndex = index
        moveSelectorView(index: index)
    }
}
