//
//  TianDiTuLayer.m
//  MapViewDemo-ObjC
//
//  Created by maklMac on 1/6/17.
//  Copyright © 2017 Esri. All rights reserved.
//

#import "TianDiTuLayer.h"
#import "TianDiTuLayerInfo.h"

@implementation TianDiTuLayer

-(instancetype)initWithTianDiTuLayerInfo: (TianDiTuLayerInfo *)tdtInfo{
    
    self = [super initWithTileInfo:tdtInfo.tileInfo fullExtent:tdtInfo.fullExtent];
    
    __weak TianDiTuLayer *weakLtl = self;
    
    [self setTileRequestHandler:^(AGSTileKey *tileKey) {
        
        // get an image – probably from a network request…
        NSString *mainURL = [tdtInfo getTianDiTuServiceURL];
        
        NSString *requestUrl1= [mainURL stringByAppendingString:@"&tilecol=%ld&tilerow=%ld&tilematrix=%ld"];
        
        NSString *requestUrl = [NSString stringWithFormat:requestUrl1,tileKey.column,tileKey.row, (tileKey.level + 1)];
        
//        NSLog(@"%@",requestUrl);
        
        NSURL* aURL = [NSURL URLWithString:requestUrl];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:aURL];
        
        UIImage *img = [UIImage imageWithData:imageData];
        
        // once we have the tile image here is where we give the tiled layer the image for the requested tile...
        [weakLtl respondWithTileKey:tileKey data:UIImagePNGRepresentation(img) error:nil];
    }];

    return self;
}


@end
