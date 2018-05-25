//
//  DecoratedLayoutViewController.swift
//  IGListKitExamples
//
//  Created by Jonathan Tamboer on 5/24/18.
//

import IGListKit
import UIKit

final class DecoratedReusableView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        backgroundColor = .blue
    }
}

final class DecoratedLayout: UICollectionViewFlowLayout {
    let viewKind = "decorated"

    private func decorationFrame(section: Int) -> CGRect? {
        guard let collectionView = collectionView else { return nil }

        if let topCell = collectionView.cellForItem(at: IndexPath(item: 0, section: section)) {
            let itemCount = collectionView.numberOfItems(inSection: section)
            var height = topCell.frame.size.height

            if itemCount > 1 {
                for item in (1..<itemCount) {
                    if let someCell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) {
                        height += someCell.frame.size.height + DecoratedLayoutSectionController.spacing
                    }
                }
            }

            return CGRect(x: topCell.frame.origin.x,
                          y: topCell.frame.origin.y,
                          width: DecoratedLayoutSectionController.spacing * 2,
                          height: height)
        }

        return nil
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section

        guard elementKind == viewKind else {
            return nil
        }

        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: IndexPath(item: 0, section: section))
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        var sections = Set<Int>()

        for attribute in attributes {
            let section = attribute.indexPath.section
            if attribute.representedElementCategory == UICollectionElementCategory.cell && !sections.contains(section) {

                let decorationAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: self.viewKind,
                                                                            with: IndexPath(item: 0, section: section))

                if let decorationFrame = self.decorationFrame(section: section) {
                    decorationAttributes.frame = decorationFrame
                    decorationAttributes.zIndex = 100
                }

                attributes.append(decorationAttributes)
                sections.insert(section)
            }
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Extremely heavy handed approach for now.
        return true
    }
}

final class DecoratedLayoutViewController: UIViewController, ListAdapterDataSource {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView: UICollectionView = {
        let layout = DecoratedLayout()
        layout.register(DecoratedReusableView.self, forDecorationViewOfKind: layout.viewKind)

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    let data = [
        SelectionModel(options: ["Leverage agile", "frameworks", "robust synopsis", "high level"]),
        SelectionModel(options: ["Bring to the table", "win-win", "survival", "strategies", "proactive domination",
                                 "At the end of the day", "going forward"]),
        SelectionModel(options: ["Aenean lacinia bibendum nulla sed consectetur. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras mattis consectetur purus sit amet fermentum.",
                                 "Donec sed odio dui. Donec id elit non mi porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed posuere consectetur est at lobortis. Cras justo odio, dapibus ac facilisis in, egestas eget quam.",
                                 "Sed posuere consectetur est at lobortis. Nullam quis risus eget urna mollis ornare vel eu leo. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum."]),
        SelectionModel(options: ["win-win", "survival", "strategies", "Bring to the table", "proactive domination",
                                 "At the end of the day", "going forward"]),
        SelectionModel(options: ["Donec sed odio dui. Donec id elit non mi porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed posuere consectetur est at lobortis. Cras justo odio, dapibus ac facilisis in, egestas eget quam.",
                                 "Aenean lacinia bibendum nulla sed consectetur. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras mattis consectetur purus sit amet fermentum.",
                                 "Sed posuere consectetur est at lobortis. Nullam quis risus eget urna mollis ornare vel eu leo. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum."])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return DecoratedLayoutSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }

}
