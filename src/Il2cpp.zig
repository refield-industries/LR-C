const Il2cpp = @This();
const std = @import("std");
const unicode = std.unicode;
const windows = std.os.windows;
const Io = std.Io;

const log = std.log.scoped(.il2cpp);

pub const Domain = *anyopaque;
pub const Assembly = *anyopaque;
pub const Image = *anyopaque;
pub const Class = *anyopaque;
pub const Method = *extern struct { address: usize };
pub const Field = *anyopaque;
pub const Type = *anyopaque;
pub const Iter = *anyopaque;

domain_get: *const fn () callconv(.c) Domain,
domain_get_assemblies: *const fn (domain: Domain, size: *usize) callconv(.c) [*]Assembly,
domain_assembly_open: *const fn (domain: Domain, name: [*:0]const u8) callconv(.c) ?Assembly,
thread_attach: *const fn (domain: Domain) callconv(.c) void,
gc_disable: *const fn () callconv(.c) void,
assembly_get_image: *const fn (assembly: Assembly) callconv(.c) Image,
image_get_name: *const fn (image: Image) callconv(.c) [*:0]const u8,
image_get_class_count: *const fn (image: Image) callconv(.c) usize,
image_get_class: *const fn (image: Image, index: usize) callconv(.c) Class,
class_from_name: *const fn (image: Image, namespace: [*:0]const u8, name: [*:0]const u8) callconv(.c) ?Class,
class_get_name: *const fn (class: Class) callconv(.c) [*:0]const u8,
class_get_namespace: *const fn (class: Class) callconv(.c) [*:0]const u8,
class_get_type: *const fn (class: Class) callconv(.c) Type,
class_get_parent: *const fn (class: Class) callconv(.c) ?Class,
class_get_interfaces: *const fn (class: Class, iter: *?Iter) callconv(.c) ?Class,
class_get_fields: *const fn (class: Class, iter: *?Iter) callconv(.c) ?Field,
class_get_methods: *const fn (class: Class, iter: *?Iter) callconv(.c) ?Method,
class_get_method_from_name: *const fn (class: Class, name: [*:0]const u8, argc: i32) callconv(.c) ?Method,
type_get_name: *const fn (t: Type) callconv(.c) [*:0]const u8,
type_get_attrs: *const fn (t: Type) callconv(.c) u32,
field_get_name: *const fn (f: Field) callconv(.c) [*:0]const u8,
field_get_type: *const fn (f: Field) callconv(.c) Type,
field_get_offset: *const fn (f: Field) callconv(.c) usize,
field_static_get_value: *const fn (f: Field, value: *usize) callconv(.c) void,
method_get_name: *const fn (m: Method) callconv(.c) [*:0]const u8,
method_get_return_type: *const fn (m: Method) callconv(.c) Type,
method_get_flags: *const fn (m: Method) callconv(.c) u32,
method_get_param_count: *const fn (m: Method) callconv(.c) u32,
method_get_param: *const fn (m: Method, index: u32) callconv(.c) Type,
method_get_param_name: *const fn (m: Method, index: u32) callconv(.c) [*:0]u8,
method_get_class: *const fn (m: Method) callconv(.c) Class,
string_new: *const fn ([*:0]const u8) callconv(.c) *String,

const LinkageError = error{SymbolNotFound};

pub fn link(against: windows.HMODULE) LinkageError!Il2cpp {
    var result: Il2cpp = undefined;
    inline for (@typeInfo(Il2cpp).@"struct".fields) |field| {
        @field(result, field.name) = @ptrCast(windows.kernel32.GetProcAddress(against, "il2cpp_" ++ field.name) orelse {
            log.err("symbol not found: '" ++ field.name ++ "'", .{});
            return error.SymbolNotFound;
        });
    }

    return result;
}

pub const String = extern struct {
    header: u128,
    length: u32,
    first_char: u16,

    pub const ToUtf8Error = error{NoSpaceLeft} || unicode.Utf16LeToUtf8Error;

    pub fn toUtf8(s: *const String, out: []u8) ToUtf8Error![]const u8 {
        if (s.length > out.len) return error.NoSpaceLeft;
        const size = try unicode.utf16LeToUtf8(out, s.chars()[0..s.length]);
        return out[0..size];
    }

    pub fn chars(s: *const String) [*]const u16 {
        return @ptrCast(&s.first_char);
    }
};
