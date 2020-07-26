//
//  SunPosition.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

public struct SunPosition {
	public var azimuth: Double
	public var altitude: Double

	public init(date: Date, latitude: Double, longitude: Double) {
        let lw: Double = Double.rad * -longitude
        let phi: Double = Double.rad * latitude
        let d: Double = SCTools.toDays(date: date)

        let c: EquatorialCoordinates = SCTools.getSunCoords(d: d)
        let H: Double = SCTools.getSiderealTime(d: d, lw: lw) - c.rightAscension

        azimuth = SCTools.getAzimuth(h: H, phi: phi, dec: c.declination)
        altitude = SCTools.getAltitude(h: H, phi: phi, dec: c.declination)
	}
}
