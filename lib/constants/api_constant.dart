final String baseUrl = "https://zaboreats.com/backend/";
final String baseUrlWS = "wss://zaboreats.com/ws/";
final String apiVersion = "driver/";

class Apis {
  static String registration = baseUrl + apiVersion + "registration";
  static String login = baseUrl + apiVersion + "login";
  static String forgotPassword = baseUrl + apiVersion + "forgetPassword";
  static String availForDelivery = baseUrl + apiVersion + 'availForDelivery';
  static String updatelocation = baseUrlWS + apiVersion + 'updatelocation';
  static String pickupRequest = baseUrl + apiVersion + 'pickup-request';
  static String acceptOrder = baseUrl + apiVersion + 'accept-delievery';
  static String orderDetail = baseUrl + apiVersion + 'getOrderDetail';
  static String changeOrderStatus = baseUrl + apiVersion + 'changeorderstatus';
  static String updateProfile = baseUrl + apiVersion + 'update';
  static String orderHistory = baseUrl + apiVersion + 'orders-history';
  static String userVerificationApi = baseUrl + apiVersion + 'verifyUserCode';
  static String updatePaymentStatus = baseUrl + apiVersion + 'user/updatePaymentStatus';
  static String runningOrder = baseUrl + apiVersion + 'getOnGoingOrders';
  static String getOrderStage = baseUrl + apiVersion + 'getOrderStages';
}
