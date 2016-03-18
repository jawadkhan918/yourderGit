//
//  Constants.h
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#ifndef Beplused_Constants_h
#define Beplused_Constants_h

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

// Fonts
#define k_Custom_Font_Name_Regular          @"TitilliumMaps29L"
#define k_Custom_Font_Name_Bold             @"TitilliumMaps26L"

#define k_APP_FONT                          @"Roboto"

#define kHTTP_GetMethod                     @"GET"
#define kHTTP_PostMethod                    @"POST"


//APPLICATION API's
#define k_MAIN_URL                          @"www.pakwedds.com/"
#define k_addLoginLog                       @"Resturant/do_save_login.php"
#define k_RestaurantList                    @"Resturant/get_resturant_list.php"
#define k_Search_Restaurants                @"Resturant/search_resturant.php"
#define k_MenuCategories                    @"Resturant/get_categorie_list.php"
#define k_DishesByCategory                  @"Resturant/get_item_list.php"
#define k_AddTable_User                     @"Resturant/do_save_tableuser.php"
#define k_GetTable_User                     @"Resturant/get_tableuser_list.php"
#define k_Add_Dish                          @"Resturant/add_dish.php"
#define k_AddOrder_Detail                   @"Resturant/add_detail.php"
#define K_Resturant_Login                   @"Resturant/login.php"
#define K_ResturantTableList                @"Resturant/get_table_list.php"
#define K_PayAmountFromPaypal               @"Resturant/user_billpaid.php"
#define k_User_Order_History                @"Resturant/get_order_history.php"
#define k_Send_Notification                 @"Resturant/send_notification.php"
#define k_Rate_Restaurant                   @"Resturant/do_add_restrating.php"
#define k_Notification_Change_Status        @"Resturant/change_notification.php"
#define k_Get_User_Notifications            @"Resturant/get_notficationby_id.php"
#define k_Get_User_Dishes                   @"Resturant/get_order_active.php"
#define k_Send_Order_ToKitchen              @"Resturant/confirm_order.php"
#define k_Delete_Dish                       @"Resturant/delete_dish.php"
#define k_AddCard                           @"Resturant/do_save_creditcard.php"
#define k_GetAllCards                       @"Resturant/get_card_list.php"
#define k_DeleteCard                        @"Resturant/delete_creditcard.php"
#define k_Dish_Splited_Info                 @"Resturant/get_dishsplited_info.php"
#define k_Service_Request                   @"Resturant/add_request.php"
#define k_Order_Served                      @"Resturant/order_place.php"
#define k_Get_Served_Orders                 @"Resturant/get_order_served.php"
#define k_Save_Waiter_Tables                @"Resturant/do_save_waitertable.php"
#define k_Get_Waiter_Tables                 @"Resturant/get_waiter_list.php"
#define k_Get_Tables_Orders                 @"Resturant/get_orderby_staffid.php"






//BARCODE SCAN MESSAGE CODES
#define k_API_Success                       0
#define k_API_Failed_Message                @"Failed! Please try again"


//USER LOGIN MESSAGE CODES
#define k_User_Login_Failed                 1
#define k_User_Login_RecordExists           2


//BARCODE SCAN MESSAGE CODES
#define k_barcode_User_already_Ontable      1
#define k_barcodeInvalid                    2
#define k_barcode_UserNotLogin              3


//NOTIFICATION ACCEPT STATUS CODES
#define k_Notification_Status_Pending       0
#define k_Notification_Status_Accept        1
#define k_Notification_Status_Reject        2
#define k_Notification_Status_Notsend       3


//LOGIN TYPE FOR LEFT SLIDE MENU
#define k_Slide_Menu_NotLogin               0
#define k_Slide_Menu_UserLogin              1
#define k_Slide_Menu_RestaurantLogin        2

























#endif
