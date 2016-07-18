#import "AppDelegate.h"

#import "CountupDetailViewController.h"

#import "Flurry.h"
#import "iRate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"6C495S2MJCSCHT6QVXTC"];
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"setupDone"]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"setupDone"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"welcome"];
        [Shared shared];
    }
    else {
        NSData *encoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        if (encoded) [Shared setShared:[NSKeyedUnarchiver unarchiveObjectWithData:encoded]];
    }
    [Shared setCurrentTab:0];
    // Reload bulletlist and immutableCalendar if necessary
	for (Countdown *countdown in sort([Shared countdowns], YES)) {
		if ([countdown calculating] || [[countdown elapsed] calculating] || [countdown waiting] || [[countdown elapsed] waiting]) {
            [countdown setupCountdown];
		}
	}
	for (Countdown *countup in sort([Shared countups], YES)) {
		if ([countup calculating] || [countup waiting]) {
            [countup setupCountup];
		}
	}
	[[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:@"version"];
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:[Shared shared]];
    [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:@"data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)initialize {
    [[iRate sharedInstance] setPreviewMode:NO];
}

@end
