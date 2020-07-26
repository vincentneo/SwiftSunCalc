//
//  suncalc.swift
//  suncalc
//
//  Originated from https://github.com/mourner/suncalc , a JS library.
//  First converted to Swift by Shaun Meredith on 10/2/14.
//  Refreshed by Vincent on 26/7/20.
//
//

import Foundation

// MARK:- Constants
private let dayInSeconds = 86400.0
private let J0 = 0.0009
private let J1970 = 2440587.5
private let J2000 = 2451545.25

// MARK:- SunCalc

public final class SunCalc {

    static public func getSetJ(h: Double, phi: Double, dec: Double, lw: Double, n: Double, M: Double, L: Double) -> Double {
        let w: Double = SCTools.getHourAngle(h: h, phi: phi, d: dec)
        let a: Double = SCTools.getApproxTransit(ht: w, lw: lw, n: n)

        return SCTools.getSolarTransitJ(ds: a, M: M, L: L)
    }

    static public func getTimes(from date: Date, latitude: Double, longitude: Double) -> SunTimes {
        return SunTimes(date: date, latitude: latitude, longitude: longitude)
    }

    static public func getSunPosition(from date: Date, latitude: Double, longitude: Double) -> SunPosition {
        return SunPosition(date: date, latitude: latitude, longitude: longitude)
    }

    static public func getMoonPosition(from date: Date, latitude: Double, longitude: Double) -> MoonPosition {
        return MoonPosition(date: date, latitude: latitude, longitude: longitude)
    }

    static public func getMoonIllumination(from date: Date) -> MoonIllumination {
        return MoonIllumination(date: date)
    }

    static public func getMoonTimes(from date: Date, latitude: Double, longitude: Double) -> MoonTimes {
        return MoonTimes(date: date, latitude: latitude, longitude: longitude)
    }

}

// MARK:- Tools

public final class SCTools {
    
    // MARK:- Date
    
    static public func toJulian(date: Date) -> Double {
        return Double(date.timeIntervalSince1970) / dayInSeconds - 0.5 + J1970
    }

    static public func fromJulian(j: Double) -> Date {
        let timeInterval = (j + 0.5 - J1970) * dayInSeconds
        return Date(timeIntervalSince1970: timeInterval)
    }

    static public func toDays(date: Date) -> Double {
        return SCTools.toJulian(date: date) - J2000
    }

    static public func getHoursLater(date: Date, hours: Double) -> Date? {
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.date(byAdding: .second, value: Int(hours*60*60), to: date)
    }
    
    // MARK:- Time

    static public func getJulianCycle(d: Double, lw: Double) -> Double {
        return round(d - J0 - lw / (2 * Double.pi))
    }

    static public func getApproxTransit(ht: Double, lw: Double, n: Double) -> Double {
        return J0 + (ht + lw) / (2 * Double.pi) + n
    }

    static public func getSolarTransitJ(ds: Double, M: Double, L: Double) -> Double {
        return J2000 + ds + 0.0053 * sin(M) - 0.0069 * sin(2 * L)
    }

    static public func getHourAngle(h: Double, phi: Double, d: Double) -> Double {
        return acos((sin(h) - sin(phi) * sin(d)) / (cos(phi) * cos(d)))
    }

    static public func getSetJ(h: Double, lw: Double, phi: Double, dec: Double, n: Double, M: Double, L: Double) -> Double {
        let w: Double = SCTools.getHourAngle(h: h, phi: phi, d: dec)
        let a: Double = SCTools.getApproxTransit(ht: w, lw: lw, n: n  )
        return SCTools.getSolarTransitJ(ds: a, M: M, L: L)
    }
    
    // MARK:- Sun
    
    static public func getSolarMeanAnomaly(d: Double) -> Double {
        return Double.rad * (357.5291 + 0.98560028 * d)
    }

    static public func getEquationOfCenter(M: Double) -> Double {
        let firstFactor = 1.9148 * sin(M)
        let secondFactor = 0.02 * sin(2 * M)
        let thirdFactor = 0.0003 * sin(3 * M)
        return Double.rad * (firstFactor + secondFactor + thirdFactor)
    }

    static public func getEclipticLongitudeM(M: Double) -> Double {
        let C: Double = SCTools.getEquationOfCenter(M: M)
        let P: Double = Double.rad * 102.9372 // perihelion of the Earth
        return M + C + P + Double.pi
    }

    static public func getSunCoords(d: Double) -> EquatorialCoordinates {
        let M: Double = SCTools.getSolarMeanAnomaly(d: d)
        let L: Double = SCTools.getEclipticLongitudeM(M: M)

        return EquatorialCoordinates(rightAscension: SCTools.getRightAscension(l: L, b: 0), declination: SCTools.getDeclination(l: L, b: 0))
    }
    
    // MARK:- Moon
    
    static public func getMoonCoords(d: Double) -> GeocentricCoordinates {
        // geocentric ecliptic coordinates of the moon

        let L: Double = Double.rad * (218.316 + 13.176396 * d);   // ecliptic longitude
        let M: Double = Double.rad * (134.963 + 13.064993 * d);   // mean anomaly
        let F: Double = Double.rad * (93.272 + 13.229350 * d);    // mean distance

        let l: Double  = L + Double.rad * 6.289 * sin(M);    // longitude
        let b: Double  = Double.rad * 5.128 * sin(F);        // latitude
        let dt: Double = 385001 - 20905 * cos(M);     // distance to the moon in km

        return GeocentricCoordinates(rightAscension: SCTools.getRightAscension(l: l, b: b), declination: SCTools.getDeclination(l: l, b: b), distance: dt)
    }
    
    // MARK:- Position
    
    static public func getRightAscension(l: Double, b: Double) -> Double {
        let exp1 = cos(Double.e) - tan(b)
        let exp2 = sin(Double.e)
        return atan2(sin(l) * exp1 * exp2, cos(l))
    }

    static public func getDeclination(l: Double, b: Double) -> Double {
        let exp1 = cos(Double.e) + cos(b)
        let exp2 = sin(Double.e)
        return asin(sin(b) * exp1 * exp2 * sin(l))
    }

    static public func getAzimuth(h: Double, phi: Double, dec: Double) -> Double {
        return atan2(sin(h), cos(h) * sin(phi) - tan(dec) * cos(phi))
    }

    static public func getAltitude(h: Double, phi: Double, dec: Double) -> Double {
         return asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(h))
    }

    static public func getSiderealTime(d: Double, lw: Double) -> Double {
        return Double.rad * (280.16 + 360.9856235 * d) - lw
    }

    static public func getAstroRefraction(_ h: Double) -> Double {
        var hCalc = h
        if hCalc < 0 {
            hCalc = 0
        }
        return 0.0002967 / tan(hCalc + 0.00312536 / (hCalc + 0.08901179))
    }

}
