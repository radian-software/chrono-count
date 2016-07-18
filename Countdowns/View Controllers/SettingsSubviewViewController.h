#import "SettingsViewController.h"

@interface SettingsSubviewViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (SettingsViewController *)getSuperview;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (void)viewWillAppear:(BOOL)animated;

@end
