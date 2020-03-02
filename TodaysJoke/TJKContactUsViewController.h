//
//  TJKContactUsViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Cloudkit/Cloudkit.h>

@interface TJKContactUsViewController : UIViewController <MFMailComposeViewControllerDelegate,UITextFieldDelegate, UITextViewDelegate>
{

    #pragma Setup Mail view Controller
    MFMailComposeViewController *mailComposer;
}
@end
