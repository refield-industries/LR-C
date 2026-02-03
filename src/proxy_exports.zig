const std = @import("std");

pub export fn GFSdkGetProtocolStatus() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkInit(
    _: usize,
    initCallback: *const fn (usize, usize) callconv(.c) void,
    _: usize,
    _: usize,
) callconv(.c) u32 {
    initCallback(0, 0);
    return 3;
}

pub export fn GFSdkInitLibrary() callconv(.c) u32 {
    return 1;
}

pub export fn GFSdkLogOut() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkLogin() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkOpenCustomerServiceCenter() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkOpenProfile() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkPayByPayment() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkQueryProductList() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkSetLanguage() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkSetServerId() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkSetServerType() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkSetUserDataPath() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkShowAccountCenter() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkShowProtocolView() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkUnInit() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkUnInitLibrary() callconv(.c) u32 {
    return 0;
}

pub export fn GFSdkSetExtraConfig() callconv(.c) u32 {
    return 0;
}
