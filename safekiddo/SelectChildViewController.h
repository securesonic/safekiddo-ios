//
//  SelectChildViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SelectChildViewControllerTypeAuthenticate,
    SelectChildViewControllerTypeSettings
    
}SelectChildViewControllerType;

@interface SelectChildViewController : UIViewController

@property(assign,nonatomic)SelectChildViewControllerType type;

@end
