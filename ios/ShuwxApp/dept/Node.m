//
//  Node.m
//  TreeTableView
//

#import "Node.h"

@implementation Node

/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId : (NSMutableArray *)childL : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand{
    self = [self init];
    if (self) {
        self.childList = childL;
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
    }
    return self;
}

- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand {
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
    }
    return self;
}

- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand : (int)type : (int)objectId : (NSString *)descrip {
    self = [self init];
       if (self) {
           self.parentId = parentId;
           self.nodeId = nodeId;
           self.name = name;
           self.depth = depth;
           self.expand = expand;
             self.type = type;
             self.objectId = objectId;
           self.descrip = descrip;
       }
       return self;
}

- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand : (int)type : (int)objectId : (NSString *)depart_name : (NSString *)head_img {
    self = [self init];
       if (self) {
           self.parentId = parentId;
           self.nodeId = nodeId;
           self.name = name;
           self.depth = depth;
           self.expand = expand;
             self.type = type;
             self.objectId = objectId;
           self.depart_name = depart_name;
            self.head_img = head_img;
       }
       return self;
}
- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand : (int)type : (int)objectId : (NSString *)depart_name : (NSString *)head_img : (NSString *)user_id {
    self = [self init];
       if (self) {
           self.parentId = parentId;
           self.nodeId = nodeId;
           self.name = name;
           self.depth = depth;
           self.expand = expand;
             self.type = type;
             self.objectId = objectId;
           self.depart_name = depart_name;
            self.head_img = head_img;
             self.user_id = user_id;
       }
       return self;
}
@end
