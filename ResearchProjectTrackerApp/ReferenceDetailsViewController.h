#import "ViewController.h"

@interface ReferenceDetailsViewController : ViewController <UITableViewDataSource>
@property NSString* token;
@property (weak, nonatomic) IBOutlet UITableView *urlTableCell;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@end
