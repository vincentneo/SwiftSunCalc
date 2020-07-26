//
//  MoonIllumination.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

public struct MoonIllumination {
	public var fraction: Double
	public var phase: Double
	public var angle: Double

	public init(date: Date) {
        let d: Double = SCTools.toDays(date: date)
        let s: EquatorialCoordinates = SCTools.getSunCoords(d: d)
        let m: GeocentricCoordinates = SCTools.getMoonCoords(d: d)

        let sdist: Double = 149598000; // distance from Earth to Sun in km

        let phi: Double = acos(sin(s.declination) * sin(m.declination) + cos(s.declination) * cos(m.declination) * cos(s.rightAscension - m.rightAscension))
        let inc: Double = atan2(sdist * sin(phi), m.distance - sdist * cos(phi))

        angle = atan2(cos(s.declination) * sin(s.rightAscension - m.rightAscension), sin(s.declination) * cos(m.declination) - cos(s.declination) * sin(m.declination) * cos(s.rightAscension - m.rightAscension))
        fraction = (1 + cos(inc)) / 2
        phase = 0.5 + 0.5 * inc * (angle < 0 ? -1 : 1) / Double.pi
	}

}
