import UIKit
import PureLayout
import GoogleMaps

struct MapCellPoint {
    let buildingName: String?
    let buildingCode: String
    let roomNumber: Int?
    let latitude: Double
    let longitude: Double
    let type: String
}

extension MapCellPoint: Equatable {
    static func == (lhs: MapCellPoint, rhs: MapCellPoint) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MapCellPoint: Hashable {
    var hashValue: Int {
        return latitude.hashValue ^ longitude.hashValue
    }
}

extension UpdatableCell where Self: MapCell {
    func update(with model: [MapCellPoint]) {
        let northmostPoint = model.map { $0.latitude }.max()
        let southmostPoint = model.map { $0.latitude }.min()
        let eastmostPoint = model.map { $0.longitude }.max()
        let westmostPoint = model.map { $0.longitude }.min()

        if let north = northmostPoint, let south = southmostPoint, let east = eastmostPoint, let west = westmostPoint {
            let northEastBound = CLLocationCoordinate2D(latitude: north, longitude: east)
            let southWestBound = CLLocationCoordinate2D(latitude: south, longitude: west)
            let bounds = GMSCoordinateBounds(coordinate: northEastBound, coordinate: southWestBound)
            if let camera = mapView.camera(for: bounds, insets: UIEdgeInsets()) {
                mapView.camera = camera
            }
        }

        for point in model {
            let position = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            let marker = GMSMarker(position: position)

            if let buildingName = point.buildingName, let roomNumber = point.roomNumber {
                marker.title = "\(point.type): \(buildingName) \(roomNumber)"
            } else {
                marker.title = point.type
            }

            switch point.type.lowercased() {
            case "laboratory", "lab": marker.icon = GMSMarker.markerImage(with: .green)
            case "recitation": marker.icon = GMSMarker.markerImage(with: .blue)
            default: marker.icon = GMSMarker.markerImage(with: .red)
            }

            marker.map = mapView
        }

        selectionStyle = .none
        updateConstraintsIfNeeded()
    }
}

extension MapCell: UpdatableCell {}

class MapCell: UITableViewCell {

    let mapView = GMSMapView()
    let schoolCoordinates = (44.563849, -123.279498)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let camera = GMSCameraPosition.camera(withLatitude: schoolCoordinates.0,
                                              longitude: schoolCoordinates.1,
                                              zoom: 13)
        mapView.setMinZoom(3, maxZoom: 16)
        mapView.frame = contentView.frame
        mapView.camera = camera
        contentView.addSubview(mapView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Open maps app with location.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    // MARK: - Layout

    override func updateConstraints() {
        NSLayoutConstraint.autoSetPriority(UILayoutPriority.required) {
            mapView.autoSetContentCompressionResistancePriority(for: .vertical)
        }
        mapView.autoPinEdgesToSuperviewEdges()

        super.updateConstraints()
    }
}
