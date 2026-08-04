// SPDX-FileCopyrightText: 2017 Ford Parsons
// SPDX-License-Identifier: CC-BY-SA-4.0
// Found on https://stackoverflow.com/a/49902760
// Doesn't support detach events because launchd's iokit integration
// only sends events on device attach

#import <Foundation/Foundation.h>
#include <xpc/xpc.h>

int main(int argc, const char * argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <on-attach-program>\n",
argv[0]);
        return 1;
    }

    NSLog(@"Started with: %s", argv[1]);

    @autoreleasepool {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        xpc_set_event_stream_handler("com.apple.iokit.matching", NULL, ^(xpc_object_t _Nonnull object) {
            const char *event = xpc_dictionary_get_string(object, XPC_EVENT_KEY_NAME);
            NSLog(@"Event: %s", event);
            dispatch_semaphore_signal(semaphore);
        });
        NSLog(@"Waiting for event...");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return system(argv[1]);
    }
}
