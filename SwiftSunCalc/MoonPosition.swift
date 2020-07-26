//
//  MoonPosition.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

public struct MoonPosition {
	var azimuth: Double
	var altitude: Double
	var distance: Double
    var parallacticAngle: Double

	init(date: Date, latitude: Double, longitude: Double) {
		let lw: Double = Double.rad * -longitude
        let phi: Double = Double.rad * latitude
        let d: Double = DateUtils.toDays(date: date)

        let coordinates: GeocentricCoordinates = MoonUtils.getMoonCoords(d: d)
        let H: Double = PositionUtils.getSiderealTime(d: d, lw: lw) - coordinates.rightAscension
        altitude = PositionUtils.getAltitude(h: H, phi: phi, dec: coordinates.declination)

        let exp = tan(phi) * cos(coordinates.declination) - sin(coordinates.declination) * cos(H)
        parallacticAngle = atan2(sin(H), exp)

        // altitude correction for refraction
        altitude += MoonPosition.astroRefraction(altitude)

        azimuth = PositionUtils.getAzimuth(h: H, phi: phi, dec: coordinates.declination)
        distance = coordinates.distance
	}

    static func astroRefraction(_ h: Double) -> Double {
        var h = h
        if h < 0 { h = 0 }

        return 0.0002967 / tan(h + 0.00312536 / (h + 0.08901179))
    }
}
