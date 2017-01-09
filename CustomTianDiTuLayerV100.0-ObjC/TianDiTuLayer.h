//
//  TianDiTuLayer.h
//  MapViewDemo-ObjC
//
//  Created by maklMac on 1/6/17.
//  Copyright © 2017 Esri. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>
#import "TianDiTuLayerInfo.h"

@interface TianDiTuLayer : AGSImageTiledLayer

-(instancetype)initWithTianDiTuLayerInfo:(TianDiTuLayerInfo *)tdtInfo;

@end
