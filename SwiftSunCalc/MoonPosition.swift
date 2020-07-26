//
//  MoonPosition.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

public struct MoonPosition {
	public var azimuth: Double
	public var altitude: Double
	public var distance: Double
    public var parallacticAngle: Double

	public init(date: Date, latitude: Double, longitude: Double) {
		let lw: Double = Double.rad * -longitude
        let phi: Double = Double.rad * latitude
        let d: Double = SCTools.toDays(date: date)

        let coordinates: GeocentricCoordinates = SCTools.getMoonCoords(d: d)
        let H: Double = SCTools.getSiderealTime(d: d, lw: lw) - coordinates.rightAscension
        altitude = SCTools.getAltitude(h: H, phi: phi, dec: coordinates.declination)

        let exp = tan(phi) * cos(coordinates.declination) - sin(coordinates.declination) * cos(H)
        parallacticAngle = atan2(sin(H), exp)

        // altitude correction for refraction
        altitude += SCTools.getAstroRefraction(altitude)

        azimuth = SCTools.getAzimuth(h: H, phi: phi, dec: coordinates.declination)
        distance = coordinates.distance
	}
}
