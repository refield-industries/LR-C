const std = @import("std");
const windows = std.os.windows;

pub var ptrGFSdkGetProtocolStatus: usize = undefined;
pub var ptrGFSdkInit: usize = undefined;
pub var ptrGFSdkInitLibrary: usize = undefined;
pub var ptrGFSdkLogOut: usize = undefined;
pub var ptrGFSdkLogin: usize = undefined;
pub var ptrGFSdkOpenCustomerServiceCenter: usize = undefined;
pub var ptrGFSdkOpenProfile: usize = undefined;
pub var ptrGFSdkPayByPayment: usize = undefined;
pub var ptrGFSdkQueryProductList: usize = undefined;
pub var ptrGFSdkSetExtraConfig: usize = undefined;
pub var ptrGFSdkSetLanguage: usize = undefined;
pub var ptrGFSdkSetServerId: usize = undefined;
pub var ptrGFSdkSetServerType: usize = undefined;
pub var ptrGFSdkSetUserDataPath: usize = undefined;
pub var ptrGFSdkShowAccountCenter: usize = undefined;
pub var ptrGFSdkShowProtocolView: usize = undefined;
pub var ptrGFSdkUnInit: usize = undefined;
pub var ptrGFSdkUnInitLibrary: usize = undefined;

pub fn link(against: windows.HMODULE) void {
    inline for (@typeInfo(@This()).@"struct".decls) |decl| {
        if (@TypeOf(@field(@This(), decl.name)) != usize) continue;

        @field(@This(), decl.name) = @intFromPtr(windows.kernel32.GetProcAddress(against, decl.name[3..]) orelse null);
    }
}

pub export fn GFSdkGetProtocolStatus() callconv(.naked) void {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkGetProtocolStatus),
    );
}

pub export fn GFSdkInit() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkInit),
    );
}

pub export fn GFSdkInitLibrary() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkInitLibrary),
    );
}

pub export fn GFSdkLogOut() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkLogOut),
    );
}

pub export fn GFSdkLogin() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkLogin),
    );
}

pub export fn GFSdkOpenCustomerServiceCenter() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkOpenCustomerServiceCenter),
    );
}

pub export fn GFSdkOpenProfile() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkOpenProfile),
    );
}

pub export fn GFSdkPayByPayment() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkPayByPayment),
    );
}

pub export fn GFSdkQueryProductList() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkQueryProductList),
    );
}

pub export fn GFSdkSetLanguage() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkSetLanguage),
    );
}

pub export fn GFSdkSetServerId() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkSetServerId),
    );
}

pub export fn GFSdkSetServerType() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkSetServerType),
    );
}

pub export fn GFSdkSetUserDataPath() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkSetUserDataPath),
    );
}

pub export fn GFSdkShowAccountCenter() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkShowAccountCenter),
    );
}

pub export fn GFSdkShowProtocolView() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkShowProtocolView),
    );
}

pub export fn GFSdkUnInit() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkUnInit),
    );
}

pub export fn GFSdkUnInitLibrary() callconv(.naked) u32 {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkUnInitLibrary),
    );
}

pub export fn GFSdkSetExtraConfig() callconv(.naked) void {
    asm volatile (
        \\ jmp *%[addr]
        :
        : [addr] "r" (ptrGFSdkSetExtraConfig),
    );
}
