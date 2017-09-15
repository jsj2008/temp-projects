require("UITableView, XYAPPSingleton,NSInteger, UIView, UIApplication, NSString, NSURL, XYAlertTool, UIScreen, SimpleAlignCell,XYAPIService, XYOrderDetailViewModel, NSMutableDictionary, XYHttpClient, XYDtoContainer,XYLocationManagerWithTimer,XYPersonalCenterViewController");
//require('JPEngine').addExtensions(['JPBlock']);
console.log("lalala");





defineClass("XYPersonalCenterViewController", {
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            tableView.deselectRowAtIndexPath_animated(indexPath, true);
            console.log("dede");
            if (indexPath.section() == 1) {
            switch (indexPath.row()) {
            case 2:
            {
                if (XYAPPSingleton.sharedInstance().currentUser().franchisee()) {
                return;
                }
                if (XYAPPSingleton.sharedInstance().currentUser().is__promotion()!== 2) {
                self.goToMyParts(false);
                }
            }
            break;
            
            case 3:
                self.goToPromotion();
            break;
            
            default:
            break;
            }
            }
            }
            }, {});


defineClass("XYOrderDetailViewModel", {
            editRepairOrderedTime_reservetime2: function(reservetime, reservetime2) {
            console.log("hehehe1");
            XYAPIService.shareInstance().editOrderTime_newTime_reservetime2_bid_success_errorString(self.orderDetail().id(), reservetime, reservetime2, self.orderDetail().bid(), block("void", function() {
                                                                                                                                                                                        console.log("hehehe2");                                                                                                        self.orderDetail().setReserveTime(reservetime);
                                                                                                                                                                                        self.orderDetail().setReserveTime2(reservetime2);
                                                                                                                                                                                        self.orderDetail().setRepairTimeString(null);
                                                                                                                                                                                        self.delegate().onPreOrderTimeEdited_noteString(true, null);
                                                                                                                                                                                        console.log("hehehe3");                                                                                                   }), block("void, NSString*", function(error) {
                                                                                                                                                                                                                                                                                                                            self.delegate().onPreOrderTimeEdited_noteString(false, error);
                                                                                                                                                                                                                                                                                                                            console.log("hehehe");                                                                                                                 }));
            }
            }, {});



//require("NSMutableDictionary, XYHttpClient, XYDtoContainer");
//XYAPIService+V1API
defineClass("XYAPIService", {
            postCoordinate_and_success_errorString: function(lat, lng, success, error) {
            console.log("hehe");
            var parameters = NSMutableDictionary.alloc().init();
            parameters.setValue_forKey(lat, "latitude");
            parameters.setValue_forKey(lng, "longitude");
            console.log("hehe1");
            var requestId = XYHttpClient.sharedInstance().requestPath_parameters_isPost_success_failure("activities/location-temp", parameters, false, block("void, id", function(response) {
                                                                            console.log("hehe2");                                                                      var dto = XYDtoContainer.mj__objectWithKeyValues(response);
                                                                                                                                                  if (dto.code() == "200") {
                                                                                                                                                  success ? success(0) : null;
                                                                                                                                                  } else {
                                                                                                                                                  error ? error("") : null;
                                                                                                                                                  }
                                                                                                                                                  }), block("void, NSString*", function(errorString) {
                                                                                                                                                            error ? error(errorString) : null;
                                                                                      console.log("hehe3");                                                                        }));
            return requestId;
            }
            }, {});



defineClass("SimpleAlignCell", {
            awakeFromNib: function() {
            self.super().awakeFromNib();
            self.xyDetailLabel().setLineBreakMode(1);
            if (UIScreen.mainScreen().bounds().height == 568) {
            self.xyDetailLabel().setPreferredMaxLayoutWidth(170);
            } else if (UIScreen.mainScreen().bounds().height == 667) {
            self.xyDetailLabel().setPreferredMaxLayoutWidth(200);
            } else if (UIScreen.mainScreen().bounds().height > 667) {
            self.xyDetailLabel().setPreferredMaxLayoutWidth(265);
            }
            }
            }, {});


//ok的 lat and:lng
defineClass("XYLocationManagerWithTimer", {
            uploadToServer: function(tempArray) {
            console.log("baba");
            var lat = tempArray.toJS()[0];
            var lng = tempArray.toJS()[1];
            XYAPIService.shareInstance().postCoordinate_and_success_errorString(lat, lng, block("void, NSInteger", function(nextUpdate){
                                                                                                   console.log("baba1");
                                                                                                   }),
                                                                                block("void, NSString*", function(hah) {
                                                                                      console.log("baba2");
                                                                                      })
                                                                                );
            }
            }, {});

//defineClass("AppDelegate"){
//    jpushNotificationCenter_didReceiveNotificationResponse_withCompletionHandler
//}

//defineClass("AppDelegate", {
//            jpushNotificationCenter_didReceiveNotificationResponse_withCompletionHandler: function(center, response, completionHandle) {
//            var userInfo = response.notification().request().content().userInfo();
//            if (response.notification().request().trigger().isKindOfClass(UNPushNotificationTrigger.class())) {
//            JPUSHService.handleRemoteNotification(userInfo);
//            var type = XYPushDto.getTypeByUserInfo(userInfo);
//            self.setCurrentBadge(self.currentBadge() + 1);
//            UIApplication.sharedApplication().setApplicationIconBadgeNumber(self.currentBadge());
//            self.rootViewController().jumpToPageByType(type);
//            } else {}
//            }
//            }, {});
//
//defineClass("SimpleAlignCell", {
//            awakeFromNib: function() {
//            self.super().awakeFromNib();
//            self.xyDetailLabel().setLineBreakMode(1);
//            }
//            }, {});
//
//defineClass("XYOrderDetailViewController", {
//            tableView: function() {
//            if (!self.valueForKey("_tableView")) {
//            var height = UIScreen.mainScreen().bounds().height - self.navigationController().navigationBar().frame().height - 60;
//            self.setValue_forKey(XYWidgetUtil.getSimpleTableView({x:0, y:0, width:UIScreen.mainScreen().bounds().width, height:height}), "_tableView");
//            self.valueForKey("_tableView").setBackgroundColor(UIColor.colorWithRed_green_blue_alpha(246 / 255, 248 / 255, 251 / 255, 1));
//            self.valueForKey("_tableView").setSeparatorColor(UIColor.colorWithRed_green_blue_alpha(210 / 255, 218 / 255, 228 / 255, 1));
//            self.valueForKey("_tableView").addSubview(self.refreshControl());
//            self.valueForKey("_tableView").setTableHeaderView(XYWidgetUtil.getSingleLine());
//            self.valueForKey("_tableView").setTableFooterView(XYWidgetUtil.getSingleLine());
//            XYOrderDetailTopCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYOrderDetailTopCell.defaultReuseId());
//            SimpleAlignCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), SimpleAlignCell.defaultReuseId());
//            SimpleEditCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), SimpleEditCell.defaultReuseId());
//            XYEditSelectCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYEditSelectCell.defaultReuseId());
//            XYCommentCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYCommentCell.defaultReuseId());
//            XYOtherFaultsCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYOtherFaultsCell.defaultReuseId());
//            XYGuaranteeStatusCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYGuaranteeStatusCell.defaultReuseId());
//            XYFaultTagsCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYFaultTagsCell.defaultReuseId());
//            XYVerifyCodeCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYVerifyCodeCell.defaultReustId());
//            XYRepairOrderPhotoCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYRepairOrderPhotoCell.defaultReuseId());
//            XYMeizuOrderPhotoCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYMeizuOrderPhotoCell.defaultReuseId());
//            XYQRCodeCell.xy__registerTableView_identifier(self.valueForKey("_tableView"), XYQRCodeCell.defaultReuseId());
//            self.valueForKey("_tableView").setDataSource(self);
//            self.valueForKey("_tableView").setDelegate(self);
//            }
//            return self.valueForKey("_tableView");
//            }
//            }, {});
