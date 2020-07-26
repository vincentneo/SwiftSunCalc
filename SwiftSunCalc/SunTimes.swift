//
//  Times.swift
//  SwiftSunCalc
//
//  Created by Vincent Neo on 26/7/20.
//

import Foundation

public struct SunTimes {
    public var sunrise: Date
    public var sunriseEnd: Date
    public var goldenHourEnd: Date
    public var solarNoon: Date
    public var goldenHour: Date
    public var sunsetStart: Date
    public var sunset: Date
    public var dusk: Date
    public var nauticalDusk: Date
    public var night: Date
    public var nadir: Date
    public var nightEnd: Date
    public var nauticalDawn: Date
    public var dawn: Date

    public init(date: Date, latitude: Double, longitude: Double) {
        let lw: Double = Double.rad * -longitude
        let phi: Double = Double.rad * latitude
        let d: Double = SCTools.toDays(date: date)

        let n: Double = SCTools.getJulianCycle(d: d, lw: lw)
        let ds: Double = SCTools.getApproxTransit(ht: 0, lw: lw, n: n)

        let M: Double = SCTools.getSolarMeanAnomaly(d: ds)
        let L: Double = SCTools.getEclipticLongitudeM(M: M)
        let dec: Double = SCTools.getDeclination(l: L, b: 0)

        let Jnoon: Double = SCTools.getSolarTransitJ(ds: ds, M: M, L: L)

        self.solarNoon = SCTools.fromJulian(j: Jnoon)
        self.nadir = SCTools.fromJulian(j: Jnoon - 0.5)

        // sun times configuration (angle, morning name, evening name)
        // unrolled the loop working on this data:
        // var times = [
        //             [-0.83, 'sunrise',       'sunset'      ],
        //             [ -0.3, 'sunriseEnd',    'sunsetStart' ],
        //             [   -6, 'dawn',          'dusk'        ],
        //             [  -12, 'nauticalDawn',  'nauticalDusk'],
        //             [  -18, 'nightEnd',      'night'       ],
        //             [    6, 'goldenHourEnd', 'goldenHour'  ]
        //             ];

        var h: Double = -0.83
        var Jset: Double = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        var Jrise: Double = Jnoon - (Jset - Jnoon)

        self.sunrise = SCTools.fromJulian(j: Jrise)
        self.sunset = SCTools.fromJulian(j: Jset)

        h = -0.3
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.sunriseEnd = SCTools.fromJulian(j: Jrise)
        self.sunsetStart = SCTools.fromJulian(j: Jset)

        h = -6
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.dawn = SCTools.fromJulian(j: Jrise)
        self.dusk = SCTools.fromJulian(j: Jset)

        h = -12
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.nauticalDawn = SCTools.fromJulian(j: Jrise)
        self.nauticalDusk = SCTools.fromJulian(j: Jset)

        h = -18
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.nightEnd = SCTools.fromJulian(j: Jrise)
        self.night = SCTools.fromJulian(j: Jset)

        h = 6
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.goldenHourEnd = SCTools.fromJulian(j: Jrise)
        self.goldenHour = SCTools.fromJulian(j: Jset)

    }
}
