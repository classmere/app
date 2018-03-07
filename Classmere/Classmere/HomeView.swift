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
        searchBar.alpha = 0
        searchBar.backgroundColor = darkColor
        searchBar.barTintColor = darkColor

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = darkColor

        addSubview(searchBar)
    }

    private func setupSearchButton() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(HomeView.searchClicked(_:)), for: .touchUpInside)
        searchButton.setTitle("Search", for: UIControlState())
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.backgroundColor = darkColor
        addSubview(searchButton)
    }

    private func setupTableView() {
        tableView.alpha = 0
        addSubview(tableView)
    }

    // MARK: - Layout

    override func updateConstraints() {
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
        showSearchBar(searchBar)
    }

    // MARK: - Animation

    func showSearchBar(_ searchBar: UISearchBar) {
        searchBarTop = true

        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()

        UIView.animate(withDuration: 0.3, animations: {
                                    searchBar.becomeFirstResponder()
                                    self.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.2,
                    animations: {
                        searchBar.alpha = 1
                        self.tableView.alpha = 1
                        self.searchButton.alpha = 0
                    }
                )
            }
        )
    }

    func dismissSearchBar(_ searchBar: UISearchBar) {
        searchBarTop = false

        UIView.animate(withDuration: 0.2,
                                   animations: {
                                    searchBar.alpha = 0
                                    self.tableView.alpha = 0
                                    self.searchButton.alpha = 1
            }, completion: { _ in
                self.setNeedsUpdateConstraints()
                self.updateConstraintsIfNeeded()
                UIView.animate(withDuration: 0.3,
                    animations: {
                        searchBar.resignFirstResponder()
                        self.layoutIfNeeded()
                    }
                )
            }
        )
    }
}
