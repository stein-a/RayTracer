//
//  WorldFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class WorldFeatures: XCTestCase {

    // Scenario: Creating a world
    // Given w ← world() Then w contains no objects And w has no light source
    func testCreatingAWorld() {
        let w = World()
        XCTAssertEqual(w.objects.count, 0)
        XCTAssertNil(w.light)
    }
    
    // Scenario: The default world
    // Given light ← point_light(point(-10, 10, -10), color(1, 1, 1))
    // And s1 ← sphere() with:
    // | material.color | (0.8, 1.0, 0.6) |
    // | material.diffuse | 0.7 |
    // | material.specular | 0.2 |
    // And s2 ← sphere() with:
    // | transform | scaling(0.5, 0.5, 0.5) |
    // When w ← default_world()
    // Then w.light = light And w contains s1 And w contains s2
    func testTheDefaultWorld() {
        let light = PointLight(pos: Point(x: -10, y: 10, z: -10),
                               int: Color(r: 1, g: 1, b: 1))
        let s1 = Sphere()
        s1.material.color = Color(r: 0.8, g: 1.0, b: 0.6)
        s1.material.diffuse = 0.7
        s1.material.specular = 0.2
        let s2 = Sphere()
        s2.transform = Matrix4.scaling(x: 0.5, y: 0.5, z: 0.5)
        let w = World.defaultWorld()
        XCTAssertEqual(w.light!, light)
        XCTAssertEqual(w.objects[0], s1)
        XCTAssertEqual(w.objects[1], s2)
    }
    
    // Scenario: Intersect a world with a ray
    // Given w ← default_world() And r ← ray(point(0, 0, -5), vector(0, 0, 1))
    // When xs ← intersect_world(w, r)
    // Then xs.count = 4 And xs[0].t = 4 And xs[1].t = 4.5
    // And xs[2].t = 5.5 And xs[3].t = 6
    func testIntersectAWorldWithARay() {
        let w = World.defaultWorld()
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let xs = w.intersect(with: r)
        XCTAssertEqual(xs.count, 4)
        XCTAssertEqual(xs.list[0].t, 4)
        XCTAssertEqual(xs.list[1].t, 4.5)
        XCTAssertEqual(xs.list[2].t, 5.5)
        XCTAssertEqual(xs.list[3].t, 6)
    }

    // Scenario: Shading an intersection
    // Given w ← default_world() And r ← ray(point(0, 0, -5), vector(0, 0, 1))
    // And shape ← the first object in w And i ← intersection(4, shape)
    // When comps ← prepare_computations(i, r) And c ← shade_hit(w, comps)
    // Then c = color(0.38066, 0.47583, 0.2855)
    func testShadingAnIntersection() {
        let w = World.defaultWorld()
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let shape = w.objects[0]
        let i = Intersection(t: 4, object: shape)
        let comps = i.prepare(with: r)
        let c = w.shade(hit: comps)
        XCTAssertEqual(c.red, 0.38066, accuracy: 0.0001)
        XCTAssertEqual(c.green, 0.47583, accuracy: 0.0001)
        XCTAssertEqual(c.blue, 0.2855, accuracy: 0.0001)
    }
    
    // Scenario: Shading an intersection from the inside
    // Given w ← default_world()
    // And w.light ← point_light(point(0, 0.25, 0), color(1, 1, 1))
    // And r ← ray(point(0, 0, 0), vector(0, 0, 1))
    // And shape ← the second object in w And i ← intersection(0.5, shape)
    // When comps ← prepare_computations(i, r) And c ← shade_hit(w, comps)
    // Then c = color(0.90498, 0.90498, 0.90498)
    func testShadingAnIntersectFromTheInside() {
        let w = World.defaultWorld()
        w.light = PointLight(pos: Point(x: 0, y: 0.25, z: 0), int: Color(r: 1, g: 1, b: 1))
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 0, z: 1))
        let shape = w.objects[1]
        let i = Intersection(t: 0.5, object: shape)
        let comps = i.prepare(with: r)
        let c = w.shade(hit: comps)
        XCTAssertEqual(c.red, 0.90498, accuracy: 0.0001)
        XCTAssertEqual(c.green, 0.90498, accuracy: 0.0001)
        XCTAssertEqual(c.blue, 0.90498, accuracy: 0.0001)
    }
    
    // Scenario: The color when a ray misses
    // Given w ← default_world() And r ← ray(point(0, 0, -5), vector(0, 1, 0))
    // When c ← color_at(w, r) Then c = color(0, 0, 0)
    func testTheColorWhenARayMisses() {
        let w = World.defaultWorld()
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 1, z: 0))
        let c = w.colorAt(ray: r)
        XCTAssertEqual(c, Color(r: 0, g: 0, b: 0))
    }
    
    // Scenario: The color with an intersection behind the ray
    // Given w ← default_world()
    // And outer ← the first object in w And outer.material.ambient ← 1
    // And inner ← the second object in w And inner.material.ambient ← 1
    // And r ← ray(point(0, 0, 0.75), vector(0, 0, -1))
    // When c ← color_at(w, r) Then c = inner.material.color
    func testTheColorWithAnIntersectionBehindTheRay() {
        let w = World.defaultWorld()
        let outer = w.objects[0]
        outer.material.ambient = 1
        let inner = w.objects[1]
        inner.material.ambient = 1
        let r = Ray(orig: Point(x: 0, y: 0, z: 0.75), dir: Vector(x: 0, y: 0, z: -1))
        let c = w.colorAt(ray: r)
        XCTAssertEqual(c, inner.material.color)
    }

    // Scenario: There is no shadow when nothing is collinear with point and light
    // Given w ← default_world() And p ← point(0, 10, 0)
    // Then is_shadowed(w, p) is false
    func testThereIsNoShadowWhenNothingIsCollinear() {
        let w = World.defaultWorld()
        let p = Point(x: 0, y: 10, z: 0)
        XCTAssertEqual(w.isShadowed(p: p), false)
    }
    
    // Scenario: The shadow when an object is between the point and the light
    // Given w ← default_world() And p ← point(10, -10, 10)
    // Then is_shadowed(w, p) is true
    func testTheShadowWhenAnObjectIsBetween() {
        let w = World.defaultWorld()
        let p = Point(x: 10, y: -10, z: 10)
        XCTAssertEqual(w.isShadowed(p: p), true)
    }
    
    // Scenario: There is no shadow when an object is behind the light
    // Given w ← default_world() And p ← point(-20, 20, -20)
    // Then is_shadowed(w, p) is false
    func testThereIsNoShadowWhenObjectIsBehindLight() {
        let w = World.defaultWorld()
        let p = Point(x: -20, y: -20, z: -20)
        XCTAssertEqual(w.isShadowed(p: p), false)
    }
    
    // Scenario: There is no shadow when an object is behind the point
    // Given w ← default_world() And p ← point(-2, 2, -2)
    // Then is_shadowed(w, p) is false
    func testNoShadowWhenObjectBehindPoint() {
        let w = World.defaultWorld()
        let p = Point(x: -2, y: 2, z: -2)
        XCTAssertEqual(w.isShadowed(p: p), false)
    }
    
    // Scenario: shade_hit() is given an intersection in shadow
    // Given w ← world() And w.light ← point_light(point(0, 0, -10), color(1, 1, 1))
    // And s1 ← sphere() And s1 is added to w
    // And s2 ← sphere() with: transform = translation(0, 0, 10) And s2 is added to w
    // And r ← ray(point(0, 0, 5), vector(0, 0, 1)) And i ← intersection(4, s2)
    // When comps ← prepare_computations(i, r) And c ← shade_hit(w, comps)
    // Then c = color(0.1, 0.1, 0.1)
    func testShadeHitIsGivenAnIntersectionInShadow() {
        let w = World()
        w.light = PointLight(pos: Point(x: 0, y: 0, z: -10), int: Color(r: 1, g: 1, b: 1))
        let s1 = Sphere()
        w.objects.append(s1)
        let s2 = Sphere()
        s2.transform = Matrix4.translation(x: 0, y: 0, z: 10)
        w.objects.append(s2)
        let r = Ray(orig: Point(x: 0, y: 0, z: 5), dir: Vector(x: 0, y: 0, z: 1))
        let i = Intersection(t: 4, object: s2)
        let comps = i.prepare(with: r)
        let c = w.shade(hit: comps)
        XCTAssertEqual(c, Color(r: 0.1, g: 0.1, b: 0.1))
    }

    // Scenario: The reflected color for a non-reflective material
    // Given w ← default_world() And r ← ray(point(0, 0, 0), vector(0, 0, 1))
    // And shape ← the second object in w And shape.material.ambient ← 1
    // And i ← intersection(1, shape)
    // When comps ← prepare_computations(i, r) And color ← reflected_color(w, comps)
    // Then color = color(0, 0, 0)
    func testTheReflectedColorForANonReflectiveMaterial() {
        let w = World.defaultWorld()
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 0, z: 1))
        let shape = w.objects[1]
        shape.material.ambient = 1
        let i = Intersection(t: 1, object: shape)
        let comps = i.prepare(with: r)
        let color = w.reflectedColor(comps: comps)
        XCTAssertEqual(color, Color(r: 0, g: 0, b: 0))
    }
    
    // Scenario: The reflected color for a reflective material
    // Given w ← default_world()
    // And shape ← plane() with:
    // material.reflective = 0.5 And transform = translation(0, -1, 0)
    // And shape is added to w
    // And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    // And i ← intersection(√2, shape)
    // When comps ← prepare_computations(i, r) And color ← reflected_color(w, comps)
    // Then color = color(0.19032, 0.2379, 0.14274)
    func testTheReflectedColorForAReflectiveMaterial() {
        let w = World.defaultWorld()
        let shape = Plane()
        shape.material.reflectivity = 0.5
        shape.transform = Matrix4.translation(x: 0, y: -1, z: 0)
        w.objects.append(shape)
        let r = Ray(orig: Point(x: 0, y: 0, z: -3), dir: Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2), object: shape)
        let comps = i.prepare(with: r)
        let color = w.reflectedColor(comps: comps)
        XCTAssertEqual(color, Color(r: 0.19034, g: 0.23793, b: 0.14275))
    }

    func testShadeHitWithAReflectiveMaterial() {
        let w = World.defaultWorld()
        let shape = Plane()
        shape.material.reflectivity = 0.5
        shape.transform = Matrix4.translation(x: 0, y: -1, z: 0)
        w.objects.append(shape)
        let r = Ray(orig: Point(x: 0, y: 0, z: -3), dir: Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2), object: shape)
        let comps = i.prepare(with: r)
        let color = w.shade(hit: comps)
        XCTAssertEqual(color, Color(r: 0.87677, g: 0.92436, b: 0.82918))
    }
    
    // Scenario: color_at() with mutually reflective surfaces
    // Given w ← world() And w.light ← point_light(point(0, 0, 0), color(1, 1, 1))
    // And lower ← plane() with:
    // | material.reflective | 1 | | transform | translation(0, -1, 0) |
    // And lower is added to w And upper ← plane() with:
    // | material.reflective | 1 | | transform | translation(0, 1, 0) |
    // And upper is added to w And r ← ray(point(0, 0, 0), vector(0, 1, 0))
    // Then color_at(w, r) should terminate successfully
    func testColorAtWithMutuallyReflectiveSurfaces() {
        let w = World()
        w.light = PointLight(pos: Point(x: 0, y: 0, z: 0), int: Color(r: 1, g: 1, b: 1))
        let lower = Plane()
        lower.material.reflectivity = 1
        lower.transform = Matrix4.translation(x: 0, y: -1, z: 0)
        w.objects.append(lower)
        let upper = Plane()
        upper.material.reflectivity = 1
        upper.transform = Matrix4.translation(x: 0, y: 1, z: 0)
        w.objects.append(upper)
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 1, z: 0))
        let color = w.colorAt(ray: r)
        XCTAssertEqual(color, Color(r: 11.4, g: 11.4, b: 11.4))
    }
    
    // Scenario: The reflected color at the maximum recursive depth
    // Given w ← default_world() And shape ← plane() with:
    // | material.reflective | 0.5 | | transform | translation(0, -1, 0) |
    // And shape is added to w And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    // And i ← intersection(√2, shape)
    // When comps ← prepare_computations(i, r) And color ← reflected_color(w, comps, 0)
    // Then color = color(0, 0, 0)
    func testTheReflectedColorAtTheMaximumRecursiveDepth() {
        let w = World.defaultWorld()
        let shape = Plane()
        shape.material.reflectivity = 0.5
        shape.transform = Matrix4.translation(x: 0, y: -1, z: 0)
        w.objects.append(shape)
        let r = Ray(orig: Point(x: 0, y: 0, z: -3),
                    dir: Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2), object: shape)
        let comps = i.prepare(with: r)
        let color = w.reflectedColor(comps: comps, remaining: 0)
        XCTAssertEqual(color, Color(r: 0, g: 0, b: 0))
    }

    // Scenario: The refracted color with an opaque surface
    // Given w ← default_world() And shape ← the first object in w
    // And r ← ray(point(0, 0, -5), vector(0, 0, 1))
    // And xs ← intersections(4:shape, 6:shape)
    // When comps ← prepare_computations(xs[0], r, xs)
    // And c ← refracted_color(w, comps, 5) Then c = color(0, 0, 0)
    func testTheRefractedColorWithAnOpaqueSurface() {
        let w = World.defaultWorld()
        let shape = w.objects[0]
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let i0 = Intersection(t: 4, object: shape)
        let i1 = Intersection(t: 6, object: shape)
        let xs = Intersections([i0, i1])
        let comps = i0.prepare(with: r, xs: xs)
        let c = w.refractedColor(comps: comps, remaining: 5)
        XCTAssertEqual(c, Color(r: 0, g: 0, b: 0))
    }
    
    // Scenario: The refracted color at the maximum recursive depth
    // Given w ← default_world() And shape ← the first object in w
    // And shape has:
    // material.transparency = 1.0 & material.refractive_index = 1.5
    // And r ← ray(point(0, 0, -5), vector(0, 0, 1))
    // And xs ← intersections(4:shape, 6:shape)
    // When comps ← prepare_computations(xs[0], r, xs)
    // And c ← refracted_color(w, comps, 0) Then c = color(0, 0, 0)
    func testTheRefractedColorAtTheMaximumRecursiveDepth() {
        let w = World.defaultWorld()
        let shape = w.objects[0]
        shape.material.transparency = 1.0
        shape.material.refractiveIndex = 1.5
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let i0 = Intersection(t: 4, object: shape)
        let i1 = Intersection(t: 6, object: shape)
        let xs = Intersections([i0, i1])
        let comps = i0.prepare(with: r, xs: xs)
        let c = w.refractedColor(comps: comps, remaining: 0)
        XCTAssertEqual(c, Color(r: 0, g: 0, b: 0))
    }
    
    // Scenario: The refracted color under total internal reflection
    // Given w ← default_world() And shape ← the first object in w
    // And shape has:
    // material.transparency = 1.0 & material.refractive_index = 1.5
    // And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
    // And xs ← intersections(-√2/2:shape, √2/2:shape)
    // # NOTE: this time you're inside the sphere, so you need
    // # to look at the second intersection, xs[1], not xs[0]
    // When comps ← prepare_computations(xs[1], r, xs)
    // And c ← refracted_color(w, comps, 5) Then c = color(0, 0, 0)
    func testTheRefractedColorUnderTotalInternalReflection() {
        let w = World.defaultWorld()
        let shape = w.objects[0]
        shape.material.transparency = 1.0
        shape.material.refractiveIndex = 1.5
        let r = Ray(orig: Point(x: 0, y: 0, z: sqrt(2)/2),
                    dir: Vector(x: 0, y: 1, z: 0))
        let i0 = Intersection(t: -sqrt(2)/2, object: shape)
        let i1 = Intersection(t: sqrt(2)/2, object: shape)
        let xs = Intersections([i0, i1])
        let comps = i1.prepare(with: r, xs: xs)
        let c = w.refractedColor(comps: comps)
        XCTAssertEqual(c, Color(r: 0, g: 0, b: 0))
    }
    
    // Scenario: The refracted color with a refracted ray
    // Given w ← default_world() And A ← the first object in w
    // And A has:
    // | material.ambient | 1.0 | | material.pattern | test_pattern() |
    // And B ← the second object in w And B has:
    // | material.transparency | 1.0 | | material.refractive_index | 1.5 |
    // And r ← ray(point(0, 0, 0.1), vector(0, 1, 0))
    // And xs ← intersections(-0.9899:A, -0.4899:B, 0.4899:B, 0.9899:A)
    // When comps ← prepare_computations(xs[2], r, xs)
    // And c ← refracted_color(w, comps, 5) Then c = color(0, 0.99878, 0.04724)
    func testTheRefractedColorWithARefractedRay() {
        let w = World.defaultWorld()
        let A = w.objects[0]
        A.material.ambient = 1.0
        A.material.pattern = GeneralPattern()
        let B = w.objects[1]
        B.material.transparency = 1.0
        B.material.refractiveIndex = 1.5
        let r = Ray(orig: Point(x: 0, y: 0, z: 0.1), dir: Vector(x: 0, y: 1, z: 0))
        let i0 = Intersection(t: -0.9899, object: A)
        let i1 = Intersection(t: -0.4899, object: B)
        let i2 = Intersection(t: 0.4899, object: B)
        let i3 = Intersection(t: 0.9899, object: A)
        let xs = Intersections([i0, i1, i2, i3])
        let comps = i2.prepare(with: r, xs: xs)
        let c = w.refractedColor(comps: comps)
        XCTAssertEqual(c, Color(r: 0, g: 0.99878, b: 0.04724))
    }
    
    // Scenario: shade_hit() with a transparent material
    // Given w ← default_world() And floor ← plane() with:
    // | transform | translation(0, -1, 0) | | material.transparency | 0.5 |
    // | material.refractive_index | 1.5 | And floor is added to w
    // And ball ← sphere() with:
    // | material.color | (1, 0, 0) | | material.ambient | 0.5 |
    // | transform | translation(0, -3.5, -0.5) | And ball is added to w
    // And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    // And xs ← intersections(√2:floor)
    // When comps ← prepare_computations(xs[0], r, xs)
    // And color ← shade_hit(w, comps, 5)
    // Then color = color(0.93642, 0.68642, 0.68642)
    func testShadeHitWithATransparentMaterial() {
        let w = World.defaultWorld()
        let floor = Plane()
        floor.transform = Matrix4.translation(x: 0, y: -1, z: 0)
        floor.material.transparency = 0.5
        floor.material.refractiveIndex = 1.5
        w.objects.append(floor)
        let ball = Sphere()
        ball.material.color = Color(r: 1, g: 0, b: 0)
        ball.material.ambient = 0.5
        ball.transform = Matrix4.translation(x: 0, y: -3.5, z: -0.5)
        w.objects.append(ball)
        let r = Ray(orig: Point(x: 0, y: 0, z: -3),
                    dir: Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i0 = Intersection(t: sqrt(2), object: floor)
        let xs = Intersections([i0])
        let comps = i0.prepare(with: r, xs: xs)
        let color = w.shade(hit: comps, remaining: 5)
        XCTAssertEqual(color, Color(r: 0.9364251, g: 0.6864251, b: 0.6864251))
    }

    // Scenario: shade_hit() with a reflective, transparent material
    // Given w ← default_world() And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    // And floor ← plane() with: | transform | translation(0, -1, 0) |
    // | material.reflective | 0.5 | material.transparency | 0.5 |
    //   material.refractive_index | 1.5 And floor is added to w
    // And ball ← sphere() with:
    // | material.color | (1, 0, 0) | | material.ambient | 0.5 |
    // | transform | translation(0, -3.5, -0.5) | And ball is added to w
    // And xs ← intersections(√2:floor)
    // When comps ← prepare_computations(xs[0], r, xs)
    // And color ← shade_hit(w, comps, 5)
    // Then color = color(0.93391, 0.69643, 0.69243)
    func testShadeHitWithAreflectiveTransparentMaterial() {
        let w = World.defaultWorld()
        let r = Ray(orig: Point(x: 0, y: 0, z: -3),
                    dir: Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let floor = Plane()
        floor.transform = Matrix4.translation(x: 0, y: -1, z: 0)
        floor.material.reflectivity = 0.5
        floor.material.transparency = 0.5
        floor.material.refractiveIndex = 1.5
        w.objects.append(floor)
        let ball = Sphere()
        ball.material.color = Color(r: 1, g: 0, b: 0)
        ball.material.ambient = 0.5
        ball.transform = Matrix4.translation(x: 0, y: -3.5, z: -0.5)
        w.objects.append(ball)
        let i0 = Intersection(t: sqrt(2), object: floor)
        let xs = Intersections([i0])
        let comps = i0.prepare(with: r, xs: xs)
        let color = w.shade(hit: comps, remaining: 5)
        XCTAssertEqual(color, Color(r: 0.9339149, g: 0.696434, b: 0.69243044))
    }

}
