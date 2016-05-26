//
//  SettingsNewConstraintSubviewViewController.h
//  Countdowns
//
//  Created by raxod502 on 6/7/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

@class SettingsViewController;
@class SettingsNewConstraintViewController;

@interface SettingsNewConstraintSubviewViewController : UITableViewController <UITableViewDelegate>

- (SettingsNewConstraintViewController *)getSuperview;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
