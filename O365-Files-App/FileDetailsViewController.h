#import "ViewController.h"
#import "office365-files-sdk/FileEntity.h"

@interface FileDetailsViewController : ViewController
@property NSString *token;
@property FileEntity *file;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButton;

@end
