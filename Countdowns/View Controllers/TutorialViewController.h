//
//  TutorialViewController.h
//  Countdowns
//
//  Created by raxod502 on 7/31/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

#import "iToast.h"
#import "Flurry.h"

@class SettingsNewTimesetViewController;

#define TEXT @[@"Normally, a countdown or countup will simply show the total amount of time until its target date or since its start date. (swipe left and right to navigate, down to exit)", @"A timseset allows you to customize how the count is computed. For instance, you could create a countdown to your next vacation that only counts the number of work days remaining.", @"To create a new timeset tap the + button. To modify an existing timeset select it from the list. To delete or reorder the timesets tap the Edit List button.", @"A timeset will consist of one or more rules for excluding or including time. To create a new timeset you should give it a name and then tap the Add Rule button.", @"A variety of options are provided for creating a rule. These options can be used individually or in combination with one another to create the desired rule.", @"For example, selecting Exclude at the top and the option Weekends will create a rule that excludes weekends from the count. After constructing the rule, tap the Add button to add the rule to your timeset.", @"Select multiple options to create more complex rules. Select Exclude at the top, Friday from the 'Day of week' option, and the 13th from the 'Specific day in month' option. This creates a rule to exclude Friday the 13th's.", @"Timesets start with all time included. Time is then excluded and included in the order of the rules, from first to last in the list displayed for the timeset.", @"Timesets can be as complex as you want. It may take a few seconds to calculate long countdowns with very complex timesets.", @"Once you have added all the rules you want for the timeset, tap Create Timeset at the bottom.", @""]

#define GRAVITY iToastGravityBottom, iToastGravityTop, iToastGravityBottom, iToastGravityCenter, iToastGravityBottom, iToastGravityBottom, iToastGravityBottom, iToastGravityBottom, iToastGravityBottom, iToastGravityCenter

@interface TutorialViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *questionableView; // Very suspicious O_o

@property NSMutableArray *images;
@property NSMutableArray *subviews;
@property iToast *currentToast;

- (IBAction)dismissTutorial:(id)sender;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)loadVisiblePages;
- (void)loadPage:(int)page;
- (void)clearPage:(int)page;
- (void)loadAllPages;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (void)viewDidLoad;
- (void)viewDidLayoutSubviews;
- (void)viewWillAppear:(BOOL)animated;

@end
