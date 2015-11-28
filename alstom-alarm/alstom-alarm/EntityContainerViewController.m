#import "EntityContainerViewController.h"
#import "EntityDescViewController.h"
#import "AlarmTableViewController.h"

@interface EntityContainerViewController ()

@end

@implementation EntityContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"entity_desc"]) {
        self.descVC = (EntityDescViewController *)[segue destinationViewController];
        [self.descVC setMParentVC:self];
    } else if ([[segue identifier] isEqualToString:@"alarm_table"]) {
        self.alarmVC = (AlarmTableViewController *)[segue destinationViewController];
        [self.alarmVC setMParentVC:self];
    }
}

- (void) resolveAlarm:(NSString *)id
{
    [self.descVC resolveAlarm:id];
}


@end
