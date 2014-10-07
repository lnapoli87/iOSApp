
//
//  JsonParser.m
//  JsonParser
//
//  Created by Gustavo on 8/20/14.
//

#import "JsonParser.h"
#import "Property.h"
#import <objc/runtime.h>

@interface JsonParser()

@property (nonatomic, strong) NSMutableArray *arrayToReturn;
@property (nonatomic, strong) NSArray *jsonArray;
@property (nonatomic, strong) NSMutableArray *properties;

@end

@implementation JsonParser

-(NSString*)toJsonString : (id)object{
    
    NSMutableString *jsonResult = [[NSMutableString alloc] initWithString:@"{"];
    
    jsonResult = [self getString :object :jsonResult];
    
    NSString *subString = [jsonResult substringWithRange:NSMakeRange(0, [jsonResult length] -1)];
    NSMutableString * result =  [[NSMutableString alloc] initWithString:subString];
    
    if([result length] == 0){return nil;}
    
    [result appendString:@"}"];
    
    return result;
}

-(NSString*)toJsonString:(id)object Property:(NSString*)name{
    
    NSMutableString *jsonResult = [[NSMutableString alloc] initWithString:@"{"];
    
    [jsonResult appendFormat:@"\"%@\" : \"%@\"", name, object];
    [jsonResult appendString:@"}"];
    
    return jsonResult;
}

-(NSMutableString *)getString : (id)object : (NSMutableString *)jsonResult{
    
    NSArray*properties = [self getPropertiesFor:[object class]];
    
    for (Property* property in properties) {
        if([property isComplexType]){
            if([property isString] || [property isNumber] || [property isDate]){
                NSString * value = [object valueForKey:property.Name];
                if(value != nil){
                    [jsonResult appendFormat:@"\"%@\" : \"%@\",", property.Name, value];
                }
            }
            else if([property isCollection]){
                
                NSArray * array = [object valueForKey:property.Name];
                
                if([array count]>0){
                    
                    [jsonResult appendFormat:@"\"%@\" : [", property.Name];
                    
                    for (NSDictionary* dicc in array) {
                        [jsonResult appendString:@"{"];
                        [self getString:dicc :jsonResult];
                        
                        NSString *subString = [jsonResult substringWithRange:NSMakeRange(0, [jsonResult length] -1)];
                        NSMutableString * result =  [[NSMutableString alloc] initWithString:subString];
                        
                        jsonResult = result;
                        
                        [jsonResult appendString:@"},"];
                    }
                    
                    NSString *subString = [jsonResult substringWithRange:NSMakeRange(0, [jsonResult length] -1)];
                    NSMutableString * result =  [[NSMutableString alloc] initWithString:subString];
                    jsonResult = result;
                    
                    [jsonResult appendString:@"],"];
                }
            }
            else{
                id complexType = [object valueForKey:property.Name];
                if(complexType != nil){
                    [jsonResult appendFormat:@"\"%@\" : {", property.Name];
                    [self getString:complexType :jsonResult];
                    
                    NSString *subString = [jsonResult substringWithRange:NSMakeRange(0, [jsonResult length] -1)];
                    NSMutableString * result =  [[NSMutableString alloc] initWithString:subString];
                    jsonResult = result;
                    
                    [jsonResult appendString:@"},"];
                }
            }
            
        }else{
            NSString * result;
            
            if(property.isBoolean){
                NSInteger value = [[object valueForKey:property.Name] integerValue];
                
                result = value ? @"true" : @"false";
            }else {
                result = [object valueForKey:property.Name];
            }
            
            if(result != nil){
                [jsonResult appendFormat:@"\"%@\" : \"%@\",", property.Name, result];
            }
        }
    }
    return jsonResult;
}

-(id)parseWithData : (NSData*)data forType : (Class) type selector:(NSArray* )keys{
    
    id parseResult;
    self.properties = [self getPropertiesFor:type];
    
    NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
    
    if(keys != nil){
        NSArray *jsonResult;
        
        for (NSString* key in keys) {
            jsonResult = [jsonArray valueForKey:key];
        }
        
        parseResult = [self parseArrayData:jsonResult Type:type];
    }
    else{
        parseResult = [self parseObjectData:jsonArray Type:type];
    }
    
    return parseResult;
}

-(id)parseObjectData : (NSDictionary*) data Type:(Class)type{
    
    id returnType = [[type alloc] init];
    
    for (Property* property in self.properties) {
        [self setValueFor:property Data:data Return:returnType];
    }
    
    return returnType;
}

-(NSMutableArray*)parseArrayData : (NSArray*) data Type : (Class)type{
    
    self.arrayToReturn = [NSMutableArray array];
    
    for (NSDictionary *dictionary in data) {
        [self.arrayToReturn addObject:[self parseObjectData:dictionary Type:type]];
    }
    
    return self.arrayToReturn;
}

-(NSMutableArray*)getPropertiesFor : (Class)type {
    NSMutableArray* result = [NSMutableArray array];
    
    Class class = type;
    
    do {
        unsigned int count, i;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        
        for (i = 0; i < count; i++) {
            
            Property * property = [[Property alloc]initWith:properties[i]];
            
            [result addObject:property];
        }
        
        free(properties);
        class = [class superclass];
    } while ([class superclass]);
    
    return result;
}

-(void)setValueFor : (Property*) property Data : (NSDictionary*) data Return : (id)returnType{
    
    if ([property isComplexType]) {
        
        if([property isString]){
            NSString* value = [data valueForKeyPath:property.Name];
            [returnType setValue:value forKeyPath:property.Name];
        }
        else if([property isNumber]){
            NSString* value = [data valueForKeyPath:property.Name];
            [returnType setInteger:[value integerValue] forKey:property.Name];
        }
        else if([property isDate]){
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
            
            NSDate *date = [dateFormatter dateFromString:[data valueForKeyPath:property.Name]];
            [returnType setValue:date forKeyPath:property.Name];
            
        }
        else if([property isCollection]){
            [self setValueForCollection:property :data :returnType];
        }
        else{
            [self setValueForComplexType:property :data :returnType];
        }
    }
    else{
        [self setValueForPrimitiveType:property :data :returnType];
    }
}

-(void)setValueForPrimitiveType :(Property*)property : (NSDictionary*)data :(id)returnType{
    
    NSString * value = [data valueForKeyPath:property.Name];
    
    if([value isKindOfClass:NSNull.class] || value == nil) return;
    
    [returnType setValue:value forKeyPath:property.Name];
}

-(void)setValueForCollection :(Property*)property : (NSDictionary*)data :(id)returnType{
    NSArray *newData = [data valueForKeyPath:property.Name];
    
    if(newData == nil) return;
    
    Class type = NSClassFromString([property getCollectionEntity]);
    
    NSArray * array = [self getPropertiesFor:type];
    NSMutableArray* returnData = [NSMutableArray array];
    
    for (NSDictionary* dicc in newData) {
        
        id entity = [[type alloc] init];
        for (Property* property in array) {
            
            [self setValueFor:property Data:dicc Return:entity];
        }
        
        [returnData addObject:entity];
        [returnType setValue:returnData forKeyPath:property.Name];
    }
}

-(void)setValueForComplexType :(Property*)property : (NSDictionary*)data :(id)returnType{
    
    Class type = NSClassFromString(property.SubStringType);
    
    if (type == nil) {//Enum
        NSString* value = [data valueForKeyPath:property.Name];
        
        if(value != nil){
            [returnType setValue:value forKeyPath:property.Name];
        }
    }
    else{
        id entity = [[type alloc] init];
        
        NSArray * array = [self getPropertiesFor:type];
        NSDictionary *newData = [data valueForKeyPath:property.Name];
        
        for (Property* property in array) {
            [self setValueFor:property Data:newData Return:entity];
        }
        
        [returnType setValue:entity forKeyPath:property.Name];
    }
}
@end