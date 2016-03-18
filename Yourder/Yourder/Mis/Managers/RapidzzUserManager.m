//
//  BeplusedUserManager.m
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import "RapidzzUserManager.h"

@implementation RapidzzUserManager

/**
 ** Login a user on Beplussed
 ** @dictParams contains the information required to login.
 **/


-(void)addLoginLog:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_addLoginLog params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginLogSuccessfully:)])
            {
                [self.delegate didLoginLogSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginLogFailed:error:)])
            {
                [self.delegate didLoginLogFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginLogFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didLoginLogFailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}
-(void)ResturantLogin:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:K_Resturant_Login params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidResturantLoginSuccessfully:)])
            {
                [self.delegate DidResturantLoginSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToResturantLogin:error:)])
            {
                [self.delegate DidFailToResturantLogin:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToResturantLogin:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToResturantLogin:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}
-(void)ResturantTableList:(NSDictionary *) params;
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:K_ResturantTableList params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidResturantTableDetailsSuccessfully:)])
            {
                [self.delegate DidResturantTableDetailsSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToResturantTableDetails:error:)])
            {
                [self.delegate DidFailToResturantTableDetails:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToResturantTableDetails:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToResturantTableDetails:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)getRestaurantList:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    //MKNetworkOperation *operation = [networkEngine operationWithPath:k_RestaurantList params:nil httpMethod:kHTTP_PostMethod];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_RestaurantList params:params httpMethod:kHTTP_PostMethod ssl:NO];
    
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetRestaurantListSuccessfully:)])
            {
                [self.delegate didGetRestaurantListSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetRestaurantListFailed:error:)])
            {
                [self.delegate didGetRestaurantListFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetRestaurantListFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didGetRestaurantListFailed:self error:self.error];
        }
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)searchRestaurant:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Search_Restaurants params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSearchRestaurantSuccessfully:)])
            {
                [self.delegate didSearchRestaurantSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSearchRestaurantfailed:error:)])
            {
                [self.delegate didSearchRestaurantfailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSearchRestaurantfailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didSearchRestaurantfailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)getRestaurantMenuCategories:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_MenuCategories params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetRestaurantMenuCategoriesSuccessfully:)])
            {
                [self.delegate didGetRestaurantMenuCategoriesSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetRestaurantMenuCategoriesFailed:error:)])
            {
                [self.delegate didGetRestaurantMenuCategoriesFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetRestaurantMenuCategoriesFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didGetRestaurantMenuCategoriesFailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)getDishesByCatID:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_DishesByCategory params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetDishesByCategorySuccessfully:)])
            {
                [self.delegate didGetDishesByCategorySuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetDishesByCategoryFailed:error:)])
            {
                [self.delegate didGetDishesByCategoryFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetDishesByCategoryFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didGetDishesByCategoryFailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}



-(void)addTableUser:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_AddTable_User params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAddTableUserSuccessfully:)])
            {
                [self.delegate didAddTableUserSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAddTableUserFailed:error:)])
            {
                [self.delegate didAddTableUserFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAddTableUserFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didAddTableUserFailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)getTableUser:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_GetTable_User params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetTableUsersSuccessfully:)])
            {
                [self.delegate didGetTableUsersSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didGetTableUsersFailed:error:)])
            {
                [self.delegate didGetTableUsersFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetTableUsersFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didGetTableUsersFailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)saveOrder:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Add_Dish params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAddOrderSuccessfully:)])
            {
                [self.delegate didAddOrderSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAddOrderFailed:error:)])
            {
                [self.delegate didAddOrderFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAddOrderFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didAddOrderFailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}

-(void)addOrderDetail:(NSDictionary *) params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_AddOrder_Detail params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAddOrderDetailSuccessfully:)])
            {
                [self.delegate didAddOrderDetailSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAddOrderDetailFailed:error:)])
            {
                [self.delegate didAddOrderDetailFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAddOrderDetailFailed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate didAddOrderDetailFailed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)PayAmountFromPaypal:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:K_PayAmountFromPaypal params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidPayAmountSuccessfully:)])
            {
                [self.delegate DidPayAmountSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToPayAmount:error:)])
            {
                [self.delegate DidFailToPayAmount:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToPayAmount:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToPayAmount:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)getUserOrderHistory:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_User_Order_History params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetOrderHistorySuccessfully:)])
            {
                [self.delegate DidGetOrderHistorySuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetOrderHistoryFailed:error:)])
            {
                [self.delegate DidGetOrderHistoryFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetOrderHistoryFailed:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidGetOrderHistoryFailed:self error:self.error];
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}


-(void)sendNotification:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Send_Notification params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidNotificationSentSuccessfully:)])
            {
                [self.delegate DidNotificationSentSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidNotificationSentFailed:error:)])
            {
                [self.delegate DidNotificationSentFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidNotificationSentFailed:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidNotificationSentFailed:self error:self.error];
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}

-(void)addRestaurantRating:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Rate_Restaurant params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidAddRatingSuccessfully:)])
            {
                [self.delegate DidAddRatingSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidAddRatingFailed:error:)])
            {
                [self.delegate DidAddRatingFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidAddRatingFailed:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidAddRatingFailed:self error:self.error];
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}

-(void)changeNotificationStatus:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Notification_Change_Status params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
    {
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidChangeNotificationStatusSuccessfully:)])
            {
                [self.delegate DidChangeNotificationStatusSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidChangeNotificationStatusFailed:error:)])
            {
                [self.delegate DidChangeNotificationStatusFailed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidChangeNotificationStatusFailed:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidChangeNotificationStatusFailed:self error:self.error];
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}

-(void)getUserNotifications:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Get_User_Notifications params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         //NSDictionary *dictJSON = completedOperation.responseJSON;
         [self handleResponse:completedOperation.responseJSON];
         
         if (self.error == nil)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetNotificationByUserIdSuccessfull:)])
             {
                 [self.delegate DidGetNotificationByUserIdSuccessfull:self];
                 
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetNotificationByUserIdFailed:error:)])
             {
                 [self.delegate DidGetNotificationByUserIdFailed:self error:self.error];
             }
         }
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetNotificationByUserIdFailed:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidGetNotificationByUserIdFailed:self error:self.error];
             
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}


-(void)getPaymentStatus:(NSDictionary *) params
{
    NSString *strUrl = @"Resturant/braintree_payment.php";
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:strUrl params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetPaymentStatusSuccessfully:)])
            {
                [self.delegate DidGetPaymentStatusSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetPaymentStatus:error:)])
            {
                [self.delegate DidFailToGetPaymentStatus:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetPaymentStatus:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToGetPaymentStatus:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}



-(void)getUserDishes:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Get_User_Dishes params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         //NSDictionary *dictJSON = completedOperation.responseJSON;
         [self handleResponse:completedOperation.responseJSON];
         
         if (self.error == nil)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetUserDishesSuccessfully:)])
             {
                 [self.delegate DidGetUserDishesSuccessfully:self];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetUserDishes:error:)])
             {
                 [self.delegate DidFailToGetUserDishes:self error:self.error];
             }
         }
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetUserDishes:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidFailToGetUserDishes:self error:self.error];
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}


-(void)PlaceOrderToKitchen:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Send_Order_ToKitchen params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         //NSDictionary *dictJSON = completedOperation.responseJSON;
         [self handleResponse:completedOperation.responseJSON];
         
         if (self.error == nil)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidOrderPlacedToKitchenSuccessfully:)])
             {
                 [self.delegate DidOrderPlacedToKitchenSuccessfully:self];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidOrderPlacedToKitchenFailed:error:)])
             {
                 [self.delegate DidOrderPlacedToKitchenFailed:self error:self.error];
             }
         }
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidOrderPlacedToKitchenFailed:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidOrderPlacedToKitchenFailed:self error:self.error];
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}


-(void)removeDishFromOrder:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Delete_Dish params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         //NSDictionary *dictJSON = completedOperation.responseJSON;
         [self handleResponse:completedOperation.responseJSON];
         
         if (self.error == nil)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidRemoveFromOrderSuccessfully:)])
             {
                 [self.delegate DidRemoveFromOrderSuccessfully:self];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(DidRemoveFromOrderFailed:error:)])
             {
                 [self.delegate DidRemoveFromOrderFailed:self error:self.error];
             }
         }
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(DidRemoveFromOrderFailed:error:)])
         {
             self.error = [[RapidzzError alloc] initWithError:error];
             [self.delegate DidRemoveFromOrderFailed:self error:self.error];
         }
         
     }];
    [networkEngine enqueueOperation:operation];
}

-(void)addCardDetail:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_AddCard params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidAddCardSuccessfully:)])
            {
                [self.delegate DidAddCardSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToAddCard:error:)])
            {
                [self.delegate DidFailToAddCard:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToAddCard:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToAddCard:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)getAllCards:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_GetAllCards params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetCardsSuccessfully:)])
            {
                [self.delegate DidGetCardsSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetCards:error:)])
            {
                [self.delegate DidFailToGetCards:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetCards:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToGetCards:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}

-(void)deleteCard:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_DeleteCard params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidDeleteCardSuccessfully:)])
            {
                [self.delegate DidDeleteCardSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToDeleteCard:error:)])
            {
                [self.delegate DidFailToDeleteCard:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToDeleteCard:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToDeleteCard:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}

-(void)getDishSplitedInfo:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Dish_Splited_Info params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetDishSplitedInfoSuccessfully:)])
            {
                [self.delegate DidGetDishSplitedInfoSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetDishSplitedInfo:error:)])
            {
                [self.delegate DidFailToGetDishSplitedInfo:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetDishSplitedInfo:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToGetDishSplitedInfo:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)getTableUsers:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_GetTable_User params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetTableUsersSuccessfully:)])
            {
                [self.delegate DidGetTableUsersSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetTableUsers:error:)])
            {
                [self.delegate DidFailToGetTableUsers:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetTableUsers:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToGetTableUsers:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}



-(void)addServiceRequest:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Service_Request params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidAddServiceRequestSuccessfully::)])
            {
                [self.delegate DidAddServiceRequestSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToAddServiceRequest:error:)])
            {
                [self.delegate DidFailToAddServiceRequest:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToAddServiceRequest:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToAddServiceRequest:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)orderServed:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Order_Served params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidOrderServedSuccessfully:)])
            {
                [self.delegate DidOrderServedSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToOrderServed:error:)])
            {
                [self.delegate DidFailToOrderServed:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToOrderServed:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToOrderServed:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}



-(void)getServedOrders:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Get_Served_Orders params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetServedOrdersSuccessfully:)])
            {
                [self.delegate DidGetServedOrdersSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetServedOrders:error:)])
            {
                [self.delegate DidFailToGetServedOrders:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetServedOrders:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToGetServedOrders:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}




-(void)SaveWaiterTables:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Save_Waiter_Tables params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidSaveWaiterTablesSuccessfully:)])
            {
                [self.delegate DidSaveWaiterTablesSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToSaveWaiterTables:error:)])
            {
                [self.delegate DidFailToSaveWaiterTables:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToSaveWaiterTables:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToSaveWaiterTables:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}



-(void)GetWaiterTables:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Get_Waiter_Tables params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetWaiterTablesSuccessfully:)])
            {
                [self.delegate DidGetWaiterTablesSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetWaiterTables:error:)])
            {
                [self.delegate DidFailToGetWaiterTables:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetWaiterTables:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToGetWaiterTables:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}


-(void)GetTablesOrders:(NSDictionary *)params
{
    RapidzzNetworkEngine *networkEngine = [RapidzzNetworkEngine sharedInstance];
    MKNetworkOperation *operation = [networkEngine operationWithPath:k_Get_Tables_Orders params:params httpMethod:kHTTP_PostMethod];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //NSDictionary *dictJSON = completedOperation.responseJSON;
        [self handleResponse:completedOperation.responseJSON];
        
        if (self.error == nil)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidGetTablesOrdersSuccessfully:)])
            {
                [self.delegate DidGetTablesOrdersSuccessfully:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetTablesOrders:error:)])
            {
                [self.delegate DidFailToGetTablesOrders:self error:self.error];
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DidFailToGetTablesOrders:error:)])
        {
            self.error = [[RapidzzError alloc] initWithError:error];
            [self.delegate DidFailToGetTablesOrders:self error:self.error];
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}





/**
 ** Register a user on Beplussed
 ** @dictParams contains the information required to register.
 **/

@end