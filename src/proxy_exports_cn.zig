const std = @import("std");

pub export fn HgSdkAutoLogin() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkGetAutoLoginAccount() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkGetProtocolStatus() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkInit(
    _: usize,
    initCallback: *const fn (usize, usize) callconv(.c) void,
    _: usize,
    _: usize,
) callconv(.c) u32 {
    initCallback(0, 0);
    return 3;
}

pub export fn HgSdkInitLibrary() callconv(.c) u32 {
    return 1;
}

pub export fn HgSdkLogOut() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkLogin() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkOpenCustomerServiceCenter() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkOpenProfile() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkPayByPayment() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkQueryPurchasedDLCList() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkSetServerType() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkSetUserDataPath() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkShowAccountCenter() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkShowProtocolView() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkStartCollect() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkStopCollect() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkUnInit() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkUnInitLibrary() callconv(.c) u32 {
    return 0;
}

pub export fn HgSdkSetExtraConfig() callconv(.c) u32 {
    return 0;
}
