@interface Shared : NSObject <NSCoding> {
    NSMutableArray *countdowns;
    NSMutableArray *countups;
    NSMutableArray *timesets;
    
    Countdown *currentCountdown;
    Timeset *currentTimeset;
    Timeset *viewedTimeset;
    Timeset *originalTimeset;
    int currentTab;
    BOOL fromCountdowns;
    BOOL skipAppear;
    
    NSMutableArray *holidays;
    NSCalendar *immutableCalendar;
    UIImage *bulletlist;
    UIDatePicker *datePicker;
}

@property NSMutableArray *countdowns;
@property NSMutableArray *countups;
@property NSMutableArray *timesets;

@property Countdown *currentCountdown;
@property Timeset *currentTimeset;
@property Timeset *viewedTimeset;
@property Timeset *originalTimeset;
@property int currentTab;
@property BOOL fromCountdowns;
@property BOOL skipAppear; // Note: not actually used...

@property NSMutableArray *holidays;
@property NSCalendar *immutableCalendar;
@property UIImage *bulletlist;
@property UIDatePicker *datePicker;

+ (id)shared;
+ (void)setShared:(Shared *)new;
- (void)reset;
- (id)init;

+ (NSMutableArray *)countdowns;
+ (NSMutableArray *)countups;
+ (NSMutableArray *)timesets;

+ (Countdown *)currentCountdown;
+ (Timeset *)currentTimeset;
+ (Timeset *)viewedTimeset;
+ (Timeset *)originalTimeset;
+ (int)currentTab;
+ (BOOL)fromCountdowns;
+ (BOOL)skipAppear;

+ (NSMutableArray *)holidays;
+ (NSCalendar *)immutableCalendar;
+ (UIImage *)bulletlist;
+ (UIDatePicker *)datePicker;

+ (void)setCountdowns:(NSMutableArray *)newCountdowns;
+ (void)setCountups:(NSMutableArray *)newCountups;
+ (void)setTimesets:(NSMutableArray *)newTimesets;
+ (void)setCurrentCountdown:(Countdown *)newCurrentCountdown;
+ (void)setCurrentTimeset:(Timeset *)newCurrentTimeset;
+ (void)setViewedTimeset:(Timeset *)newViewedTimeset;
+ (void)setOriginalTimeset:(Timeset *)newOriginalTimeset;
+ (void)setCurrentTab:(int)newCurrentTab;
+ (void)setFromCountdowns:(BOOL)newFromCountdowns;
+ (void)setSkipAppear:(BOOL)newSkipAppear;
+ (void)setHolidays:(NSMutableArray *)newHolidays;
+ (void)setImmutableCalendar:(NSCalendar *)newImmutableCalendar;
+ (void)setBulletlist:(UIImage *)newBulletlist;
+ (void)setDatePicker:(UIDatePicker *)newDatePicker;

// Generated with Python!

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
