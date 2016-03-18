//
//  BeplusedUserManager.h
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RapidzzError.h"
#import "RapidzzBaseManager.h"

@class RapidzzUserManager;

@protocol RapidzzUserManagerDelegate <NSObject>

@optional


-(void)didLoginLogSuccessfully:(RapidzzBaseManager *)manager;
-(void)didLoginLogFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didGetRestaurantListSuccessfully:(RapidzzBaseManager *)manager;
-(void)didGetRestaurantListFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didSearchRestaurantSuccessfully:(RapidzzBaseManager *)manager;
-(void)didSearchRestaurantfailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didGetRestaurantMenuCategoriesSuccessfully:(RapidzzBaseManager *)manager;
-(void)didGetRestaurantMenuCategoriesFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didGetDishesByCategorySuccessfully:(RapidzzBaseManager *)manager;
-(void)didGetDishesByCategoryFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didAddTableUserSuccessfully:(RapidzzBaseManager *)manager;
-(void)didAddTableUserFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didGetTableUsersSuccessfully:(RapidzzBaseManager *)manager;
-(void)didGetTableUsersFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didAddOrderSuccessfully:(RapidzzBaseManager *)manager;
-(void)didAddOrderFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)didAddOrderDetailSuccessfully:(RapidzzBaseManager *)manager;
-(void)didAddOrderDetailFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidResturantLoginSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToResturantLogin:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidResturantTableDetailsSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToResturantTableDetails:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidPayAmountSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToPayAmount:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetOrderHistorySuccessfully:(RapidzzBaseManager *)manager;
-(void)DidGetOrderHistoryFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidNotificationSentSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidNotificationSentFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidAddRatingSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidAddRatingFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidChangeNotificationStatusSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidChangeNotificationStatusFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetNotificationByUserIdSuccessfull:(RapidzzBaseManager *)manager;
-(void)DidGetNotificationByUserIdFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetPaymentStatusSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetPaymentStatus:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetUserDishesSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetUserDishes:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidOrderPlacedToKitchenSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidOrderPlacedToKitchenFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidRemoveFromOrderSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidRemoveFromOrderFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidAddCardSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToAddCard:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetCardsSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetCards:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidDeleteCardSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToDeleteCard:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

 -(void)DidGetDishSplitedInfoSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetDishSplitedInfo:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetTableUsersSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetTableUsers:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidAddServiceRequestSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToAddServiceRequest:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidOrderServedSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToOrderServed:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetServedOrdersSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetServedOrders:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidSaveWaiterTablesSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToSaveWaiterTables:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetWaiterTablesSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetWaiterTables:(RapidzzBaseManager *)manager error:(RapidzzError *)error;

-(void)DidGetTablesOrdersSuccessfully:(RapidzzBaseManager *)manager;
-(void)DidFailToGetTablesOrders:(RapidzzBaseManager *)manager error:(RapidzzError *)error;



@end

@interface RapidzzUserManager : RapidzzBaseManager

@property (nonatomic, weak) id<RapidzzUserManagerDelegate> delegate;

-(void)getUserDishes:(NSDictionary *)params;
-(void)ResturantTableList:(NSDictionary *) params;
-(void)ResturantLogin:(NSDictionary *) params;
-(void)addLoginLog:(NSDictionary *) params;
-(void)searchRestaurant:(NSDictionary *) params;
-(void)getRestaurantMenuCategories:(NSDictionary *) params;
-(void)getDishesByCatID:(NSDictionary *) params;
-(void)addTableUser:(NSDictionary *) params;
-(void)getTableUser:(NSDictionary *) params;
-(void)saveOrder:(NSDictionary *) params;
-(void)addOrderDetail:(NSDictionary *) params;
-(void)PayAmountFromPaypal:(NSDictionary *) params;
-(void)getUserOrderHistory:(NSDictionary *) params;
-(void)sendNotification:(NSDictionary *)params;
-(void)addRestaurantRating:(NSDictionary *)params;
-(void)changeNotificationStatus:(NSDictionary *)params;
-(void)getUserNotifications:(NSDictionary *)params;
-(void)getPaymentStatus:(NSDictionary *) params;
-(void)PlaceOrderToKitchen:(NSDictionary *)params;
-(void)removeDishFromOrder:(NSDictionary *)params;
-(void)addCardDetail:(NSDictionary *) params;
-(void)getAllCards:(NSDictionary *) params;
-(void)deleteCard:(NSDictionary *) params;
-(void)getDishSplitedInfo:(NSDictionary *) params;
-(void)getRestaurantList:(NSDictionary *) params;
-(void)getTableUsers:(NSDictionary *)params;
-(void)addServiceRequest:(NSDictionary *)params;
-(void)orderServed:(NSDictionary *)params;
-(void)getServedOrders:(NSDictionary *)params;
-(void)SaveWaiterTables:(NSDictionary *)params;
-(void)GetWaiterTables:(NSDictionary *)params;
-(void)GetTablesOrders:(NSDictionary *)params;




@end
