//
//  PositionUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

class PositionUtils {
	
	class func getRightAscension(l:Double, b:Double) -> Double {
        let exp1 = cos(Double.e) - tan(b)
        let exp2 = sin(Double.e)
		return atan2(sin(l) * exp1 * exp2, cos(l))
	}
	
	class func getDeclination(l:Double, b:Double) -> Double {
        let exp1 = cos(Double.e) + cos(b)
        let exp2 = sin(Double.e)
		return asin(sin(b) * exp1 * exp2 * sin(l))
	}
	
	class func getAzimuth(h:Double, phi:Double, dec:Double) -> Double {
		return atan2(sin(h), cos(h) * sin(phi) - tan(dec) * cos(phi))
	}
	
	class func getAltitude(h:Double, phi:Double, dec:Double) -> Double {
		 return asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(h))
	}
	
	class func getSiderealTime(d:Double, lw:Double) -> Double {
		return Double.rad * (280.16 + 360.9856235 * d) - lw
	}
    
    class func getAstroRefraction(h:Double) -> Double {
        var hCalc:Double = h
        if (hCalc < 0) {
            hCalc = 0;
        }
        return 0.0002967 / tan(hCalc + 0.00312536 / (hCalc + 0.08901179));
    }
    
}
