const std = @import("std");
const interceptor = @import("interceptor.zig");
const Il2cpp = @import("Il2cpp.zig");

comptime {
    _ = @import("proxy_exports.zig");
}

const windows = std.os.windows;
const unicode = std.unicode;
const Io = std.Io;

const DLL_PROCESS_ATTACH = 1;

extern "kernel32" fn AllocConsole() callconv(.winapi) void;
extern "kernel32" fn FreeConsole() callconv(.winapi) void;

const gameassembly_name = unicode.utf8ToUtf16LeStringLiteral("GameAssembly.dll");
var base: usize = 0;
var il2cpp: Il2cpp = undefined;

pub const std_options: std.Options = .{
    .logFn = colorlessLog,
};

fn onAttach() void {
    const log = std.log.scoped(.lr);

    FreeConsole();
    AllocConsole();

    std.debug.print(
        \\           @                                                   
        \\           #:@                                      @@@        
        \\           #@::#@                                 @:@%         
        \\           ##@::::@                            @=::@%@         
        \\           *##@-:::::@ @##::::::::::==@ @@@%::::::@%%@         
        \\           @###@=:::@@#::::::::::-@*#%=::@::::::@@%%@          
        \\           @#####@==*@@%#########@@@:#*+=::@@@##@%%%@          
        \\            %####@%%@#%%#:=:=::#%%%%@@:@#@::@**@%%%@           
        \\            *##@%%%@%%:@#@#+**@@@%%:%@#%%%@-:@@%%%%            
        \\         @@+*#@:#%%%%:@##@@@@@@#@:%@*%%%%%%%@@%@@*##@@         
        \\         @+*##@@@#%#@*@########%%@%%%%%%%@@#@-@##++##@         
        \\         @@%#@*##@@#+++***********@%%%@@@*####@#@*+*##@        
        \\       @==+@@*##@*++@++++++++++++++*@#%-@**##@=@@*++@@         
        \\    @===%+:@##@-****@=++++++++++*#++***@---*##=-@#@##*++*@@@   
        \\     **@@@:-@==##%@@@@====+++++**.+++++*@--=*##+-@....@**++@   
        \\    @@---=--@#@#@@   #@@......-@@@@@@=..%@:-=##@-=@..@####@    
        \\    @--@+--=@+@:@#######@.......@@@@@.@.@+#@:#:--=@@@##@@      
        \\    @:----=*@::::#--###@.......@ .###%..++**#@---=@=-@#**@     
        \\ @@==@-=@#=@::::::%@@@.........@######@@++***:----===-@#*++@   
        \\@===**##*==@::::::....@.........#--##@:@++***#@:----=@###++++@ 
        \\  @@%#@**=++@::::......@@@@@@....:@+:::::@**###@:---@@@##*++++@
        \\    @++@==++**@:................:::::::@ %**##@*#@@#*# %#**+@  
        \\    ++@==++**@@   @@@............:#@    @+***@#*******@        
        \\   @++===++**@                          @+***###*******@       
        \\  @++@===+***#@                         ++****#%##******@      
        \\ @++++*@%=+**@@                         @++***##@###*****@     
        \\      @@@@@@@                            *++*####%@###**@      
        \\                                          @@@@@##@ @@@         
        \\
    , .{});

    var threaded: Io.Threaded = .init_single_threaded;
    defer threaded.deinit();
    const io = threaded.ioBasic();

    log.info("Successfully injected. Waiting for the game startup.", .{});

    while (base == 0) : (base = @intFromPtr(windows.kernel32.GetModuleHandleW(gameassembly_name))) {
        io.sleep(.fromNanoseconds(200 * std.time.ns_per_ms), .awake) catch {};
    } else {
        io.sleep(.fromSeconds(2), .awake) catch {};
    }

    log.info("GameAssembly: {X}", .{base});

    il2cpp = Il2cpp.link(@ptrFromInt(base)) catch |err| {
        log.err("failed to link il2cpp symbols: {t}", .{err});
        return;
    };

    const domain = il2cpp.domain_get();
    const uwr_module = il2cpp.assembly_get_image(il2cpp.domain_assembly_open(domain, "UnityEngine.UnityWebRequestModule.dll").?);
    const web_request_utils = il2cpp.class_from_name(uwr_module, "UnityEngineInternal", "WebRequestUtils").?;
    const unity_web_request = il2cpp.class_from_name(uwr_module, "UnityEngine.Networking", "UnityWebRequest").?;

    const make_initial_url = il2cpp.class_get_method_from_name(web_request_utils, "MakeInitialUrl", 2).?;
    const internal_set_url = il2cpp.class_get_method_from_name(unity_web_request, "InternalSetUrl", 1).?;
    const set_url = il2cpp.class_get_method_from_name(unity_web_request, "set_url", 1).?;

    const gameplay_module = il2cpp.assembly_get_image(il2cpp.domain_assembly_open(domain, "Gameplay.Beyond.dll").?);
    const camera_mono = il2cpp.class_from_name(gameplay_module, "Beyond.Gameplay.View", "CameraMono").?;
    const evaluate_all_touched_entities = il2cpp.class_get_method_from_name(camera_mono, "EvaluateAllTouchedEntities", 0).?;

    WebRequestPatch.init(set_url.address, make_initial_url.address, internal_set_url.address);
    SloppyRSAPatch.init();
    interceptor.write(evaluate_all_touched_entities.address, &.{0xC3}); // Dither

    log.info("Successfully initialized! Time to play Endfield!", .{});
}

// Patch out the SRSA (Sloppy RSA)
const SloppyRSAPatch = struct {
    const write_srsa_check: usize = 0xA20ABFF;
    const read_srsa_check: usize = 0xA20B354;

    pub fn init() void {
        interceptor.write(base + write_srsa_check, &.{ 0x90, 0x90 });
        interceptor.write(base + read_srsa_check, &.{ 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 });
    }
};

const WebRequestPatch = struct {
    const log = std.log.scoped(.uwr);
    const https_prefix = "https://";

    var uwrInternalSetUrl: *const fn (uwr: *anyopaque, url: *Il2cpp.String) callconv(.c) void = undefined;
    var makeInitialUrl: *const fn (target: *Il2cpp.String, local: *Il2cpp.String) callconv(.c) *Il2cpp.String = undefined;

    pub fn init(uwr_set_url: usize, make_initial_url: usize, uwr_internal_set_url: usize) void {
        makeInitialUrl = @ptrFromInt(make_initial_url);
        uwrInternalSetUrl = @ptrFromInt(uwr_internal_set_url);

        interceptor.replace(uwr_set_url, onUwrSetUrl);
    }

    fn onUwrSetUrl(uwr: *anyopaque, url_string: *Il2cpp.String) callconv(.c) void {
        var utf8_conversion_buf: [8192]u8 = undefined;
        var replacement_buf: [8192]u8 = undefined;
        const localhost = il2cpp.string_new("http://localhost/");

        const url = url_string.toUtf8(&utf8_conversion_buf) catch |err| {
            log.err("failed to convert URL to utf8: {t}", .{err});
            return uwrInternalSetUrl(uwr, makeInitialUrl(url_string, localhost));
        };

        log.debug("{s}", .{url});

        if (std.mem.startsWith(u8, url, https_prefix)) {
            if (std.mem.findScalar(u8, url[https_prefix.len..], '/')) |i| {
                const replacement = std.fmt.bufPrintSentinel(
                    &replacement_buf,
                    "{s}/{s}",
                    .{ "http://127.0.0.1:10001", url[https_prefix.len + i + 1 ..] },
                    0,
                ) catch |err| {
                    log.err("failed to replace url: {t} (url: {s})", .{ err, url });
                    return uwrInternalSetUrl(uwr, makeInitialUrl(url_string, localhost));
                };

                log.debug("replacement: {s}", .{replacement});
                return uwrInternalSetUrl(uwr, makeInitialUrl(il2cpp.string_new(replacement), localhost));
            }
        }

        uwrInternalSetUrl(uwr, makeInitialUrl(url_string, localhost));
    }
};

pub export fn DllMain(_: windows.HINSTANCE, reason: windows.DWORD, _: windows.LPVOID) callconv(.winapi) windows.BOOL {
    if (reason == DLL_PROCESS_ATTACH) {
        const thread = std.Thread.spawn(.{}, onAttach, .{}) catch unreachable;
        thread.detach();
    }

    return 1;
}

fn colorlessLog(
    comptime level: std.log.Level,
    comptime scope: @EnumLiteral(),
    comptime format: []const u8,
    args: anytype,
) void {
    var buffer: [64]u8 = undefined;
    var stderr = std.debug.lockStderr(&buffer).terminal();
    defer std.debug.unlockStderr();

    stderr.mode = .no_color;
    return std.log.defaultLogFileTerminal(level, scope, format, args, stderr) catch {};
}
