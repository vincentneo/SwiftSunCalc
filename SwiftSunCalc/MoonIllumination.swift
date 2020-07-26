//
//  MoonIllumination.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

public struct MoonIllumination {
	var fraction: Double
	var phase: Double
	var angle: Double
	
	init(date: Date) {
        let d:Double = DateUtils.toDays(date: date)
        let s:EquatorialCoordinates = SunUtils.getSunCoords(d: d)
        let m:GeocentricCoordinates = MoonUtils.getMoonCoords(d: d)
        
        let sdist:Double = 149598000; // distance from Earth to Sun in km
        
        let phi:Double = acos(sin(s.declination) * sin(m.declination) + cos(s.declination) * cos(m.declination) * cos(s.rightAscension - m.rightAscension))
        let inc:Double = atan2(sdist * sin(phi), m.distance - sdist * cos(phi))
        
        angle = atan2(cos(s.declination) * sin(s.rightAscension - m.rightAscension), sin(s.declination) * cos(m.declination) - cos(s.declination) * sin(m.declination) * cos(s.rightAscension - m.rightAscension))
        fraction = (1 + cos(inc)) / 2
        phase = 0.5 + 0.5 * inc * (angle < 0 ? -1 : 1) / Double.pi
	}
	
}
