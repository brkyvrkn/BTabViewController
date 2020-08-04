//
//  BTabViewController.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 31.07.2020
//  Copyright © 2020 foo. All rights reserved.
//

import UIKit

open class BTabViewController: UIViewController {

    // MARK: - Properties
    // Models
    internal var tabItems: [BTabItemModel] = []
    internal var tabList: [BTabModel] = []
    internal var selectedTabItem: BTabItemModel? {
        didSet {
            self.activateTab(order: self.selectedTabItem?.order ?? -1)
            if tabCollectionView != nil {
                DispatchQueue.main.async {
                    self.tabCollectionView?.performBatchUpdates({
//                    print("Reload tabs")
                        var idxs = [IndexPath(item: self.selectedTabItem?.order ?? 0, section: 0)]
                        if let old = oldValue {
                            idxs.append(IndexPath(item: old.order, section: 0))
                        }
                        self.tabCollectionView?.reloadItems(at: idxs)
                    }, completion: nil)
                }
            }
        }
    }
    // UIViews
    open var tabCollectionView: UICollectionView?
    open var tabLayout: UICollectionViewFlowLayout?
    open var horizontalScrollView: UIScrollView?
    open var containers: [UIView] = []
    open var cellProvider: [BTabCellProvider] = []
    // Tabs
    open var tabsGap: CGFloat = 8
    open var tabInset: CGFloat = 12
    open var tabWidth: CGFloat = 80
    open var tabsHeight: CGFloat = 50
    open var tabAlignment: NSTextAlignment = .left
    // Flags
    open var fitTabs: Bool = false
    open var indicatorIsRounded: Bool = true
    open var isIndicatorVisible: Bool = true
    open var isIndicatorSlide: Bool = false
    // Indicator
    open var indicatorView: UIView?
    open var indicatorHeight: CGFloat = 4
    open var indicatorWidth: CGFloat = 20
    open var indicatorColor: UIColor = .init(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    private var indicatorLeading: CGFloat = 0

    override open func loadView() {
        super.loadView()
//        print("BTabViewController:::::>\(#function)")
        self.cellProvider = [BTabCellProvider(reuseIdentifier: "BTabCell", class_: BTabCell.self)]
        setView(tabList: self.tabList, tabItems: self.tabItems)
    }

    /// Draw custom views
    override open func viewDidLoad() {
        super.viewDidLoad()
//        print(String(format: "%@\n%@\n%@", "BTabViewController:::::>\(#function)", tabList, tabItems))
        if tabCollectionView == nil && tabLayout == nil {
            tabLayout = UICollectionViewFlowLayout()
            tabLayout?.scrollDirection = .horizontal
            tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tabLayout!)
            initCollectionView(tabCollectionView!)
        }
        if horizontalScrollView == nil {
            horizontalScrollView = UIScrollView(frame: .zero)
            initScrollView(horizontalScrollView!)
        }
        if indicatorView == nil, tabCollectionView != nil {
            indicatorView = UIView(frame: .zero)
        }
    }

    /// Attach custom views and frame operations
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if tabCollectionView != nil && tabLayout != nil {
            attachTabs(base: tabCollectionView!)
            tabCollectionView!.performBatchUpdates({
                self.tabCollectionView?.reloadSections(IndexSet(integersIn: 0..<(self.tabCollectionView?.numberOfSections ?? 1)))
            }, completion: nil)
        }
        if horizontalScrollView != nil {
            attachViews(base: horizontalScrollView!)
            horizontalScrollView?.contentSize = .init(width: CGFloat(containers.count) * view.frame.width,
                                                      height: horizontalScrollView!.frame.height)
            if selectedTabItem == nil, !tabItems.isEmpty {
                selectedTabItem = tabItems[0]
                if tabCollectionView != nil, tabCollectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) != nil {
                    tabCollectionView?.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
                }
            }
        }
        if indicatorView != nil, selectedTabItem != nil {
            attachIndicator(instance: indicatorView!, forView: tabCollectionView!, selected: selectedTabItem!, forceUpdate: false)
        }
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if horizontalScrollView != nil, selectedTabItem != nil {
            scrollTab(horizontalScrollView!, base: view, toTab: selectedTabItem!)
            DispatchQueue.main.async {
                self.tabCollectionView?.performBatchUpdates({
                    self.tabCollectionView?.reloadSections(IndexSet(integersIn: 0..<(self.tabCollectionView?.numberOfSections ?? 1)))
                }, completion: nil)
            }
        }

        guard indicatorView != nil, tabCollectionView != nil else { return }
        attachIndicator(instance: indicatorView!, forView: tabCollectionView!, selected: selectedTabItem!, forceUpdate: true)
    }

    open func setView(tabList: [BTabModel], tabItems: [BTabItemModel]) {
//        print(String(format: "%@\n%@\n%@", "BTabViewController:::::>\(#function)", tabList, tabItems))
        self.tabItems = tabItems
        self.tabList = tabList
        if tabList.count != tabItems.count {
            fatalError(NSLocalizedString("Tab count must equal to the target size", comment: ""))
        }
    }

    open func listTab(_ target: UIViewController, didSelect item: BTabItemModel, index: Int) {
//        print(String(format: "%@\ntarget=%@\tselected=%@\tindex=%d", "BTabViewController:::::>\(#function)", target, item.title, index))
    }

    open func listTab(_ target: UIViewController, tabSwitched toItem: BTabItemModel) {
//        print(String(format: "%@\ntarget=%@\tswitched to=%@", "BTabViewController:::::>\(#function)", target, to.title))
    }

    // MARK: - Tabs
    /// Tab collection view initializer stuff
    /// * Delegate and data source connection
    /// * Cell registration based on the cell provider in order to support custom tab cells
    /// * Flag assignment
    /// - Parameter collectionView: Tab collection view
    private func initCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        if !cellProvider.isEmpty {
            for cProvider in cellProvider {
                if cProvider.nib != nil {
                    if cProvider.forSupplementaryViewOfKind != nil {
                        collectionView.register(cProvider.nib!, forSupplementaryViewOfKind: cProvider.forSupplementaryViewOfKind!, withReuseIdentifier: cProvider.identifier)
                    } else {
                        collectionView.register(cProvider.nib!, forCellWithReuseIdentifier: cProvider.identifier)
                    }
                } else if cProvider.class_ != nil {
                    if cProvider.forSupplementaryViewOfKind != nil {
                        collectionView.register(cProvider.class_!, forSupplementaryViewOfKind: cProvider.forSupplementaryViewOfKind!, withReuseIdentifier: cProvider.identifier)
                    } else {
                        collectionView.register(cProvider.class_!, forCellWithReuseIdentifier: cProvider.identifier)
                    }
                }
            }
        } else {
            collectionView.register(BTabCell.self, forCellWithReuseIdentifier: BTabCell.identifier)
        }
    }

    /// Determine the collection cell size for all tabs
    /// - Parameter base: Tabs collection view
    /// - Returns: Size of the tab
    open func setTabSizes(base: UICollectionView) -> CGSize {
        if fitTabs {
            let gapWidth = CGFloat(tabItems.count - 1) * tabsGap
            let outzoneWidth = (2 * tabInset) + gapWidth
            let inzoneWidth = base.bounds.width - outzoneWidth
            let cellWidth = inzoneWidth / CGFloat(tabItems.count)
            self.tabWidth = cellWidth
            if isIndicatorVisible {
                return .init(width: cellWidth, height: base.bounds.height - indicatorHeight)
            }
            return .init(width: cellWidth, height: base.bounds.height)
        }
        if isIndicatorVisible {
            return .init(width: tabWidth, height: base.bounds.height - indicatorHeight)
        }
        return .init(width: tabWidth, height: base.bounds.height)
    }

    /// Add the tab collection view inside of the parent view
    /// - Parameter base: Base tab collection view
    private func attachTabs(base: UICollectionView) {
        guard base.tag != 69 else { return }
        base.tag = 69
        view.addSubview(base)
        base.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            .init(item: base, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            .init(item: base, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: base, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: base, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tabsHeight)])
        base.layoutIfNeeded()
        let context = base.collectionViewLayout.invalidationContext(forBoundsChange: base.bounds)
        context.contentOffsetAdjustment = .zero
        base.collectionViewLayout.invalidateLayout(with: context)
        base.layoutSubviews()
        base.collectionViewLayout.finalizeCollectionViewUpdates()
    }

    /// Change the activation state correctly
    /// - Note: It does not reload the tab collection view,
    /// just set the activation state of the tab item for tabItems in BTabViewController.swift
    /// - Parameter order: Order of the tab with left-most direction
    open func activateTab(order: Int) {
        if order < tabItems.count {
            for idx in 0..<tabItems.count {
                if idx == order {
                    tabItems[idx].setActive(true)
                } else {
                    tabItems[idx].setActive(false)
                }
            }
        }
    }

    /// Attach indicator to the bottom of the selected tab if indicator is visible
    /// - Parameters:
    ///   - instance: Indicator view
    ///   - forView: Corresponding tab collection view
    ///   - selected: Selected tab model to distinguish the leading margin
    ///   - forceUpdate: If indicator has already drawn, 'true' value will draw again without copy
    open func attachIndicator(instance: UIView, forView: UICollectionView, selected: BTabItemModel, forceUpdate: Bool) {
        guard isIndicatorVisible else { return }
        if (instance.tag == 89 && forceUpdate) || instance.tag != 89 {
            if instance.tag != 89 {
                view.addSubview(instance)
                instance.tag = 89
            }
            instance.backgroundColor = indicatorColor
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.removeConstraints(instance.constraints)
            if let cell = forView.layoutAttributesForItem(at: IndexPath(item: selected.order, section: 0)) {
                let lead = view.frame.intersection(cell.frame).origin.x
//                print("lead Frame origin = \(lead)")
                for constraint in view.constraints {
                    if let firstObj = constraint.firstItem as? UIView, firstObj.tag == 89 {
                        constraint.isActive = false
                        view.removeConstraint(constraint)
                    }
                }
                indicatorLeading = lead
                NSLayoutConstraint.activate([
                    .init(item: instance, attribute: .bottom, relatedBy: .equal, toItem: forView, attribute: .bottom, multiplier: 1, constant: 0),
                    .init(item: instance, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: lead),
                    .init(item: instance, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: indicatorHeight),
                    .init(item: instance, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: indicatorWidth)])
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    instance.layoutIfNeeded()
                }, completion: { _ in
                    if self.indicatorIsRounded {
                        instance.layer.cornerRadius = instance.frame.height / 2
                        instance.clipsToBounds = true
                    }
                })
            }
        } else {
//            print("BTabViewController:::::>Indicator has already visible")
        }
    }

    // MARK: - Contents
    /// Initialization stuff for UIScrollView
    /// * Delegate connection
    /// * Some flag assignment
    /// - Parameter scrollView: Newly instantiated scroll view
    private func initScrollView(_ scrollView: UIScrollView) {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.isMultipleTouchEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
    }

    /// Get n-th order child view controller
    /// - Parameter order: Given order
    /// - Returns: Target if instantiated
    open func getTarget(of order: Int) -> UIViewController? {
        if order > 0 && order < self.tabList.count {
            return self.tabList[order].target
        }
        return nil
    }

    /// Get child view controller with given id
    /// - Parameter id: Identifier of child view controller
    /// - Returns: Target if instantiated
    open func getTarget(_ id: String) -> UIViewController? {
        return self.tabList.first(where: { $0.id == id })?.target
    }

    /// Get child view inside of the BTabViewController
    /// - Parameter order: n-th order (begins with zero)
    /// - Returns: UIView if container list contains
    open func getContainer(of order: Int) -> UIView? {
        if order > 0 && order < self.containers.count {
            return self.containers[order]
        }
        return nil
    }

    /// Add scroll view inside of the parent view w.r.t the size of tab collection view
    /// - Parameter base: Base scroll view
    private func attachViews(base: UIScrollView) {
        guard self.tabCollectionView != nil else {
            fatalError(NSLocalizedString("Tabs must be creted and attached into view before the targets are created", comment: ""))
        }
        guard base.tag != 99 else { return }
        base.tag = 99
        view.addSubview(base)
        base.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            .init(item: base, attribute: .top, relatedBy: .equal, toItem: self.tabCollectionView!, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: base, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: base, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: base, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)])
        base.layoutIfNeeded()

        for idx in 0..<self.tabList.count {
            let item = self.tabList[idx]
            _ = self.tabItems[idx]
            let container = UIView(frame: .zero)
            container.tag = 100 + idx
            containers.append(container)
            addContainer(base: base, container: container, child: item.target)
        }
        containers.sort(by: { (prev, next) in
            prev.tag < next.tag
        })
        for tIdx in 0..<self.tabList.count {
            _ = self.tabList[tIdx]
            let container = self.containers[tIdx]

            container.translatesAutoresizingMaskIntoConstraints = false
            var leadingView: UIView = base
            var trailingView: UIView = base
            if tIdx - 1 >= 0 {
                leadingView = self.containers[tIdx - 1]
            }
            if tIdx + 1 < self.tabList.count {
                trailingView = self.containers[tIdx + 1]
            }
            NSLayoutConstraint.activate([
                .init(item: container, attribute: .leading, relatedBy: .equal, toItem: leadingView, attribute: leadingView is UIScrollView ? .leading : .trailing, multiplier: 1, constant: 0),
                .init(item: container, attribute: .trailing, relatedBy: .equal, toItem: trailingView, attribute: trailingView is UIScrollView ? .trailing : .leading, multiplier: 1, constant: 0)
            ])
            container.layoutIfNeeded()
        }
    }

    /// Add container view safely to the parent view
    /// - Parameters:
    ///   - base: Parent view of the container
    ///   - container: Newly instantiated view which will be added into the base
    ///   - child: Target view controller
    ///   - extraConstraints: Exclude the side and with-height constraint of the container view
    private func addContainer(base: UIView, container: UIView, child: UIViewController, extraConstraints: [NSLayoutConstraint] = []) {
        base.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        var containerConstraints = [
            container.topAnchor.constraint(equalTo: base.topAnchor, constant: 0),
            container.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: 0)
        ]
        if !extraConstraints.isEmpty {
            containerConstraints.append(contentsOf: extraConstraints)
        }
        NSLayoutConstraint.activate(containerConstraints)

        addChild(child)
        container.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: container.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            child.view.heightAnchor.constraint(equalTo: base.heightAnchor, multiplier: 1),
            child.view.widthAnchor.constraint(equalTo: base.widthAnchor, multiplier: 1)
        ])

        child.didMove(toParent: self)
    }

    /// Give the offset to the scroll view according to the tab
    /// - Parameters:
    ///   - scrollView: Horizontal scroll view
    ///   - base: Which view is the parent of the scroll view
    ///   - toTab: Corresponding tab to determine the offset
    private func scrollTab(_ scrollView: UIScrollView, base: UIView, toTab: BTabItemModel) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                let origin_X = CGFloat(toTab.order) * base.frame.width
                let origin_Y = CGFloat(0)
                let newOrigin = CGPoint(x: origin_X, y: origin_Y)
                scrollView.setContentOffset(newOrigin, animated: false)
            }, completion: { _ in
                scrollView.layoutIfNeeded()
            })
        }
    }
}

// MARK: - Collection View
extension BTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabItems.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let provider = cellProvider.first {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: provider.identifier, for: indexPath) as? BTabCell {
                let item = tabItems[indexPath.row]
                cell.configureCell(item)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BTabCell.identifier, for: indexPath) as? BTabCell {
                let item = tabItems[indexPath.row]
                cell.configureCell(item)
                return cell
            }
        }
        return UICollectionViewCell()
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = tabItems[indexPath.row]
        let target = tabList[indexPath.row].target
        guard horizontalScrollView != nil else { return }
        self.listTab(target, didSelect: item, index: indexPath.row)
        scrollTab(horizontalScrollView!, base: view, toTab: item)
        if let sTab = selectedTabItem, sTab != item {
            selectedTabItem = item
            if indicatorView != nil {
                attachIndicator(instance: indicatorView!, forView: collectionView, selected: selectedTabItem!, forceUpdate: true)
            }
            self.listTab(target, tabSwitched: item)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.setTabSizes(base: collectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return tabsGap
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: tabInset, bottom: 0, right: tabInset)
    }
}

// MARK: - Scroll View
extension BTabViewController: UIScrollViewDelegate {

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            let pageIdx = Int(floor(scrollView.contentOffset.x / view.bounds.width))
            let viewScrollDiff = Float(Int(scrollView.contentOffset.x) % Int(view.bounds.width))
            let indicatorOffset = CGFloat(Float(tabWidth) * (viewScrollDiff / Float(view.bounds.width)))
            if pageIdx < 0 || pageIdx >= tabItems.count {
                // Do nothing when scrolls over bounds.
                return
            }
//                print("scroll multiplier: \(viewScrollMultiplier), indicator offset: \(indicatorOffset)")
            if isIndicatorVisible, indicatorView != nil, isIndicatorSlide {
                for constr in view.constraints {
                    if let consV = constr.firstItem as? UIView, consV.tag == 89, constr.firstAttribute == .leading {
                        var newLeading = indicatorLeading
                        let veloX = scrollView.panGestureRecognizer.velocity(in: scrollView).x
//                        print("Velo: \(veloX)")
                        if veloX < 0 {
                            newLeading = indicatorLeading + indicatorOffset
                            constr.isActive = false
                            constr.constant = newLeading
                            constr.isActive = true
                            indicatorView?.layoutIfNeeded()
                        }
                    }
                }
            }
            if selectedTabItem != nil, tabCollectionView != nil, indicatorView != nil, selectedTabItem?.order != pageIdx {
                selectedTabItem = tabItems[pageIdx]
            }
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            let pageIdx = Int(floor(scrollView.contentOffset.x / view.bounds.width))
            if indicatorView != nil, tabCollectionView != nil, selectedTabItem != nil {
                if selectedTabItem?.order != pageIdx, pageIdx > 0, pageIdx < tabItems.count {
                    selectedTabItem = tabItems[pageIdx]
                }
                attachIndicator(instance: indicatorView!, forView: tabCollectionView!, selected: selectedTabItem!, forceUpdate: true)
            }
        }
    }
}
