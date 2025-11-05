const std = @import("std");
const math = @import("zlm.zig");
const assert = std.debug.assert;

const math_f32 = math.as(f32);

const vec2 = math_f32.vec2;
const vec3 = math_f32.vec3;
const vec4 = math_f32.vec4;

const Vec2 = math_f32.Vec2;
const Vec3 = math_f32.Vec3;
const Vec4 = math_f32.Vec4;

const Mat3 = math_f32.Mat3;
const Mat4 = math_f32.Mat4;

test "default generic is f32" {
    const T = @TypeOf(vec2(1, 2).x);
    try std.testing.expectEqual(T, f32);
}

test "as()" {
    const math_u64 = math.as(u64);
    const T = @TypeOf(math_u64.vec2(3, 4).x);
    try std.testing.expectEqual(T, u64);
}

test "constructors" {
    const v2 = vec2(1, 2);
    assert(v2.x == 1);
    assert(v2.y == 2);

    const v3 = vec3(1, 2, 3);
    assert(v3.x == 1);
    assert(v3.y == 2);
    assert(v3.z == 3);

    const v4 = vec4(1, 2, 3, 4);
    assert(v4.x == 1);
    assert(v4.y == 2);
    assert(v4.z == 3);
    assert(v4.w == 4);
}

test "vec2 arithmetics" {
    const a = vec2(2, 1);
    const b = vec2(1, 2);

    assert(std.meta.eql(Vec2.add(a, b), vec2(3, 3)));
    assert(std.meta.eql(Vec2.sub(a, b), vec2(1, -1)));
    assert(std.meta.eql(Vec2.mul(a, b), vec2(2, 2)));
    assert(std.meta.eql(Vec2.div(a, b), vec2(2, 0.5)));
    assert(std.meta.eql(Vec2.scale(a, 2.0), vec2(4, 2)));

    assert(Vec2.dot(a, b) == 4.0);

    assert(Vec2.length2(a) == 5.0);
    assert(Vec2.length(a) == std.math.sqrt(5.0));
    assert(Vec2.length(b) == std.math.sqrt(5.0));
}

test "vec3 arithmetics" {
    const a = vec3(2, 1, 3);
    const b = vec3(1, 2, 3);

    assert(std.meta.eql(Vec3.add(a, b), vec3(3, 3, 6)));
    assert(std.meta.eql(Vec3.sub(a, b), vec3(1, -1, 0)));
    assert(std.meta.eql(Vec3.mul(a, b), vec3(2, 2, 9)));
    assert(std.meta.eql(Vec3.div(a, b), vec3(2, 0.5, 1)));
    assert(std.meta.eql(Vec3.scale(a, 2.0), vec3(4, 2, 6)));

    assert(Vec3.dot(a, b) == 13.0);

    assert(Vec3.length2(a) == 14.0);
    assert(Vec3.length(a) == std.math.sqrt(14.0));
    assert(Vec3.length(b) == std.math.sqrt(14.0));

    assert(std.meta.eql(Vec3.cross(vec3(1, 2, 3), vec3(-7, 8, 9)), vec3(-6, -30, 22)));
}

test "vec4 arithmetics" {
    const a = vec4(2, 1, 4, 3);
    const b = vec4(1, 2, 3, 4);

    assert(std.meta.eql(Vec4.add(a, b), vec4(3, 3, 7, 7)));
    assert(std.meta.eql(Vec4.sub(a, b), vec4(1, -1, 1, -1)));
    assert(std.meta.eql(Vec4.mul(a, b), vec4(2, 2, 12, 12)));
    assert(std.meta.eql(Vec4.div(a, b), vec4(2, 0.5, 4.0 / 3.0, 3.0 / 4.0)));
    assert(std.meta.eql(Vec4.scale(a, 2.0), vec4(4, 2, 8, 6)));

    assert(Vec4.dot(a, b) == 28.0);

    assert(Vec4.length2(a) == 30.0);
    assert(Vec4.length(a) == std.math.sqrt(30.0));
    assert(Vec4.length(b) == std.math.sqrt(30.0));
}

test "vec3 <-> vec4 interop" {
    const v = vec3(1, 2, 3);
    const pos = vec4(1, 2, 3, 1);
    const dir = vec4(1, 2, 3, 0);

    assert(std.meta.eql(Vec3.toAffinePosition(v), pos));
    assert(std.meta.eql(Vec3.toAffineDirection(v), dir));

    assert(std.meta.eql(Vec3.fromAffinePosition(pos), v));
    assert(std.meta.eql(Vec3.fromAffineDirection(dir), v));
}

// TODO: write tests for mat2, mat3

// zig fmt: off
test "mat4 arithmetics" {
    const id = Mat4.identity;

    const mat = Mat4{
        .fields = [4][4]f32{
            // zig fmt: off
            [4]f32{  1,  2,  3,  4 },
            [4]f32{  5,  6,  7,  8 },
            [4]f32{  9, 10, 11, 12 },
            [4]f32{ 13, 14, 15, 16 },
            // zig-fmt: on
        },
    };

    const mat_mult_by_mat_by_hand = Mat4{
        .fields = [4][4]f32{
            // zig fmt: off
            [4]f32{ 90, 100, 110, 120 },
            [4]f32{ 202, 228, 254, 280 },
            [4]f32{ 314, 356, 398, 440 },
            [4]f32{ 426, 484, 542, 600 },
            // zig-fmt: on
        },
    };

    const mat_transposed = Mat4{
        .fields = [4][4]f32{
            [4]f32{ 1, 5, 9, 13 },
            [4]f32{ 2, 6, 10, 14 },
            [4]f32{ 3, 7, 11, 15 },
            [4]f32{ 4, 8, 12, 16 },
        },
    };

    const mat_a = Mat4{
        .fields = [4][4]f32{
            [4]f32{ 1, 2, 3, 1 },
            [4]f32{ 2, 3, 1, 2 },
            [4]f32{ 3, 1, 2, 3 },
            [4]f32{ 1, 2, 3, 1 },
        },
    };

    const mat_b = Mat4{
        .fields = [4][4]f32{
            [4]f32{ 3, 2, 1, 3 },
            [4]f32{ 2, 1, 3, 2 },
            [4]f32{ 1, 3, 2, 1 },
            [4]f32{ 3, 2, 1, 3 },
        },
    };

    const mat_a_times_b = Mat4{
        .fields = [4][4]f32{
            [4]f32{ 13, 15, 14, 13 },
            [4]f32{ 19, 14, 15, 19 },
            [4]f32{ 22, 19, 13, 22 },
            [4]f32{ 13, 15, 14, 13 },
        },
    };

    const mat_b_times_a = Mat4{
        .fields = [4][4]f32{
            [4]f32{ 13, 19, 22, 13 },
            [4]f32{ 15, 14, 19, 15 },
            [4]f32{ 14, 15, 13, 14 },
            [4]f32{ 13, 19, 22, 13 },
        },
    };

    // make sure basic properties are not messed up
    assert(std.meta.eql(Mat4.mul(id, id), id));
    assert(std.meta.eql(Mat4.mul(mat, id), mat));
    assert(std.meta.eql(Mat4.mul(id, mat), mat));

    assert(std.meta.eql(Mat4.mul(mat, mat), mat_mult_by_mat_by_hand));
    assert(std.meta.eql(Mat4.mul(mat_a, mat_b), mat_a_times_b));
    assert(std.meta.eql(Mat4.mul(mat_b, mat_a), mat_b_times_a));

    assert(std.meta.eql(Mat4.transpose(mat), mat_transposed));
}
// zig fmt: on

test "vec4 transform" {
    const mat = Mat4{
        .fields = [4][4]f32{
            // zig fmt: off
            [4]f32{ 1, 2, 3, 4 },
            [4]f32{ 5, 6, 7, 8 },
            [4]f32{ 9, 10, 11, 12 },
            [4]f32{ 13, 14, 15, 16 },
            // zig-fmt: on
        },
    };

    const transform = Mat4{
        .fields = [4][4]f32{
            // zig fmt: off
            [4]f32{ 2, 0, 0, 0 },
            [4]f32{ 0, 2, 0, 0 },
            [4]f32{ 0, 0, 2, 0 },
            [4]f32{ 10, 20, 30, 1 },
            // zig-fmt: on
        },
    };

    const vec = vec4(1, 2, 3, 4);

    assert(std.meta.eql(Vec4.transform(vec, mat), vec4(90, 100, 110, 120)));
    assert(std.meta.eql(Vec4.transform(vec4(1, 2, 3, 1), transform), vec4(12, 24, 36, 1)));
    assert(std.meta.eql(Vec4.transform(vec4(1, 2, 3, 0), transform), vec4(2, 4, 6, 0)));
}

test "vec2 swizzle" {
    assert(std.meta.eql(vec4(0, 1, 1, 2), vec2(1, 2).swizzle("0x1y")));
    assert(std.meta.eql(vec2(2, 1), vec2(1, 2).swizzle("yx")));
}

test "vec3 swizzle" {
    assert(std.meta.eql(vec4(1, 1, 2, 3), vec3(1, 2, 3).swizzle("xxyz")));
    assert(std.meta.eql(vec2(3, 3), vec3(1, 2, 3).swizzle("zz")));
}

test "vec4 swizzle" {
    assert(std.meta.eql(vec4(3, 4, 2, 1), vec4(1, 2, 3, 4).swizzle("zwyx")));
    assert(std.meta.eql(@as(f32, 3), vec4(1, 2, 3, 4).swizzle("z")));
}

test "radians and degrees conversion" {
    const pi = std.math.pi;
    
    // Test radians conversion (degrees to radians)
    try std.testing.expectApproxEqAbs(0.0, math_f32.radians(0.0), 1e-6);
    try std.testing.expectApproxEqAbs(pi / 2.0, math_f32.radians(90.0), 1e-6);
    try std.testing.expectApproxEqAbs(pi, math_f32.radians(180.0), 1e-6);
    try std.testing.expectApproxEqAbs(2.0 * pi, math_f32.radians(360.0), 1e-6);
    
    // Test degrees conversion (radians to degrees)
    try std.testing.expectApproxEqAbs(0.0, math_f32.degrees(0.0), 1e-6);
    try std.testing.expectApproxEqAbs(90.0, math_f32.degrees(pi / 2.0), 1e-6);
    try std.testing.expectApproxEqAbs(180.0, math_f32.degrees(pi), 1e-6);
    try std.testing.expectApproxEqAbs(360.0, math_f32.degrees(2.0 * pi), 1e-6);
    
    // Test round-trip conversion
    try std.testing.expectApproxEqAbs(45.0, math_f32.degrees(math_f32.radians(45.0)), 1e-6);
    try std.testing.expectApproxEqAbs(pi / 4.0, math_f32.radians(math_f32.degrees(pi / 4.0)), 1e-6);
}

test "rotate matrix" {
    const pi = std.math.pi;
    
    // Test rotation around Z axis by 90 degrees
    const mat = Mat4.identity;
    const rotated = math_f32.rotate(mat, pi / 2.0, vec3(0, 0, 1));
    
    // After rotating 90 degrees around Z, a point at (1, 0, 0) should be at (0, 1, 0)
    const point = vec4(1, 0, 0, 1);
    const result = Vec4.transform(point, rotated);
    
    try std.testing.expectApproxEqAbs(0.0, result.x, 1e-6);
    try std.testing.expectApproxEqAbs(1.0, result.y, 1e-6);
    try std.testing.expectApproxEqAbs(0.0, result.z, 1e-6);
    try std.testing.expectApproxEqAbs(1.0, result.w, 1e-6);
    
    // Test rotation around X axis by 90 degrees
    const rotated_x = math_f32.rotate(Mat4.identity, pi / 2.0, vec3(1, 0, 0));
    const point_y = vec4(0, 1, 0, 1);
    const result_x = Vec4.transform(point_y, rotated_x);
    
    try std.testing.expectApproxEqAbs(0.0, result_x.x, 1e-6);
    try std.testing.expectApproxEqAbs(0.0, result_x.y, 1e-6);
    try std.testing.expectApproxEqAbs(1.0, result_x.z, 1e-6);
    try std.testing.expectApproxEqAbs(1.0, result_x.w, 1e-6);
}

test "scale matrix" {
    // Test uniform scaling
    const mat = Mat4.identity;
    const scaled = math_f32.scale(mat, vec3(2, 2, 2));
    
    const point = vec4(1, 2, 3, 1);
    const result = Vec4.transform(point, scaled);
    
    try std.testing.expectApproxEqAbs(2.0, result.x, 1e-6);
    try std.testing.expectApproxEqAbs(4.0, result.y, 1e-6);
    try std.testing.expectApproxEqAbs(6.0, result.z, 1e-6);
    try std.testing.expectApproxEqAbs(1.0, result.w, 1e-6);
    
    // Test non-uniform scaling
    const scaled_non_uniform = math_f32.scale(Mat4.identity, vec3(1, 2, 3));
    const result2 = Vec4.transform(point, scaled_non_uniform);
    
    try std.testing.expectApproxEqAbs(1.0, result2.x, 1e-6);
    try std.testing.expectApproxEqAbs(4.0, result2.y, 1e-6);
    try std.testing.expectApproxEqAbs(9.0, result2.z, 1e-6);
    try std.testing.expectApproxEqAbs(1.0, result2.w, 1e-6);
}

test "translate matrix" {
    // Test basic translation
    const mat = Mat4.identity;
    const translated = math_f32.translate(mat, vec3(10, 20, 30));
    
    const point = vec4(1, 2, 3, 1);
    const result = Vec4.transform(point, translated);
    
    try std.testing.expectApproxEqAbs(11.0, result.x, 1e-6);
    try std.testing.expectApproxEqAbs(22.0, result.y, 1e-6);
    try std.testing.expectApproxEqAbs(33.0, result.z, 1e-6);
    try std.testing.expectApproxEqAbs(1.0, result.w, 1e-6);
    
    // Test that directions (w=0) are not affected by translation
    const direction = vec4(1, 0, 0, 0);
    const result_dir = Vec4.transform(direction, translated);
    
    try std.testing.expectApproxEqAbs(1.0, result_dir.x, 1e-6);
    try std.testing.expectApproxEqAbs(0.0, result_dir.y, 1e-6);
    try std.testing.expectApproxEqAbs(0.0, result_dir.z, 1e-6);
    try std.testing.expectApproxEqAbs(0.0, result_dir.w, 1e-6);
}

test "value_ptr" {
    const mat = Mat4{
        .fields = [4][4]f32{
            [4]f32{ 1, 2, 3, 4 },
            [4]f32{ 5, 6, 7, 8 },
            [4]f32{ 9, 10, 11, 12 },
            [4]f32{ 13, 14, 15, 16 },
        },
    };
    
    const ptr = math_f32.value_ptr(&mat);
    
    // Verify the pointer points to the beginning of the matrix data
    try std.testing.expectEqual(@intFromPtr(&mat.fields[0][0]), @intFromPtr(ptr));
    
    // Verify we can read the first element through the pointer
    try std.testing.expectEqual(@as(f32, 1), ptr.*);
}

test "combined transformations" {
    const pi = std.math.pi;
    
    // Test combining translation, rotation, and scaling
    var mat = Mat4.identity;
    mat = math_f32.translate(mat, vec3(10, 0, 0));
    mat = math_f32.rotate(mat, pi / 2.0, vec3(0, 0, 1));
    mat = math_f32.scale(mat, vec3(2, 2, 2));
    
    const point = vec4(1, 0, 0, 1);
    const result = Vec4.transform(point, mat);
    
    // After translation by (10,0,0), rotation 90° around Z, and scaling by 2:
    // (1,0,0,1) -> (11,0,0,1) after translation
    // (11,0,0,1) -> (0,11,0,1) after rotation
    // (0,11,0,1) -> (0,22,0,1) after scaling
    try std.testing.expectApproxEqAbs(0.0, result.x, 1e-5);
    try std.testing.expectApproxEqAbs(22.0, result.y, 1e-5);
    try std.testing.expectApproxEqAbs(0.0, result.z, 1e-5);
    try std.testing.expectApproxEqAbs(1.0, result.w, 1e-5);
}
