import UIKit
import PureLayout

final class HomeView: UIView {

    let darkColor: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

    var searchBarTop = false
    let searchBar = UISearchBar.newAutoLayout()
    let searchButton = UIButton(type: .custom)
    let tableView = UITableView.newAutoLayout()
    var searchButtonWidthConstraint: NSLayoutConstraint?
    var searchButtonEdgeConstraint: NSLayoutConstraint?

    var didSetupConstraints = false

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        self.backgroundColor = .white
        setupSearchBar()
        setupSearchButton()
        setupTableView()
    }

    private func setupSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.isTranslucent = false
        searchBar.alpha = 0
        searchBar.backgroundColor = darkColor
        searchBar.barTintColor = darkColor
        searchBar.tintColor = Theme.Color.blue.uicolor

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = darkColor

        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: Theme.Color.blue.uicolor]
        UIBarButtonItem.appearance()
            .setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey : AnyObject],
                                    for: UIControlState())

        addSubview(searchBar)
    }

    private func setupSearchButton() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(HomeView.searchClicked(_:)), for: .touchUpInside)
        searchButton.setTitle("Search", for: UIControlState())
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.backgroundColor = darkColor
//        searchButton.layer.cornerRadius = 4
        addSubview(searchButton)
    }

    private func setupTableView() {
        tableView.alpha = 0
        addSubview(tableView)
    }

    // MARK: - Layout

    override func updateConstraints() {
        if !didSetupConstraints {
            searchBar.autoAlignAxis(toSuperviewAxis: .vertical)
            searchBar.autoSetDimension(.height, toSize: 50)
            searchBar.autoMatch(.width, to: .width, of: self)
            searchBar.autoPinEdge(toSuperviewEdge: .top)

            searchButton.autoSetDimension(.height, toSize: 60)
            searchButton.autoAlignAxis(toSuperviewAxis: .vertical)

            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoPinEdge(toSuperviewEdge: .leading)
            tableView.autoPinEdge(toSuperviewEdge: .trailing)
            tableView.autoPinEdge(toSuperviewEdge: .bottom)
            tableView.autoPinEdge(.top, to: .bottom, of: searchBar)
        }

        searchButtonWidthConstraint?.autoRemove()
        searchButtonEdgeConstraint?.autoRemove()

        if searchBarTop {
            searchButtonWidthConstraint = searchButton.autoMatch(.width, to: .width, of: self)
            searchButtonEdgeConstraint = searchButton.autoPinEdge(toSuperviewEdge: .top)
        } else {
            searchButtonWidthConstraint = searchButton.autoSetDimension(.width, toSize: 200)
            searchButtonEdgeConstraint = searchButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        }

        super.updateConstraints()
    }

    // MARK: - User Interaction

    @objc func searchClicked(_ sender: UIButton!) {
        showSearchBar()
    }

    // MARK: - Animation

    func showSearchBar() {
        searchBarTop = true

        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()

        UIView.animate(withDuration: 0.3, animations: {
                                    self.searchBar.becomeFirstResponder()
                                    self.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.2,
                    animations: {
                        self.searchBar.alpha = 1
                        self.tableView.alpha = 1
                        self.searchButton.alpha = 0
                    }
                )
            }
        )
    }

    func dismissSearchBar() {
        searchBarTop = false

        UIView.animate(withDuration: 0.2,
                                   animations: {
                                    self.searchBar.alpha = 0
                                    self.tableView.alpha = 0
                                    self.searchButton.alpha = 1
            }, completion: { _ in
                self.setNeedsUpdateConstraints()
                self.updateConstraintsIfNeeded()
                UIView.animate(withDuration: 0.3,
                    animations: {
                        self.searchBar.resignFirstResponder()
                        self.layoutIfNeeded()
                    }
                )
            }
        )
    }
}