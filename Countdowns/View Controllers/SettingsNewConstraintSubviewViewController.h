@class SettingsViewController;
@class SettingsNewConstraintViewController;

@interface SettingsNewConstraintSubviewViewController : UITableViewController <UITableViewDelegate>

- (SettingsNewConstraintViewController *)getSuperview;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
