ReceiptKit
==========

Simple StoreKit receipt validation and processing for iOS 7. This only supports the universal receipt format.

Follow the [ReceiptKit Twitter account](http://twitter.com/receiptkit) for code updates and news.

##Receipt Data

Under iOS 7 receipt data can be accessed like this:

    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];

##Apple Root Certificate

You should download your own version of the CA root certificate:

See: http://www.apple.com/certificateauthority/

Certificate can be found here: http://www.apple.com/appleca/AppleIncRootCertificate.cer

##Usage

To verify a receipt and decode the payload:

    NSData *receipt = ..., cert = ...
    RTKReceiptParser *parser = [[RTKReceiptParser alloc] initWithReceipt:receipt certificate:cert];
    BOOL isBundleIDValid = [parser isReceiptValidForDevice:@"com.example-corp.app-name"];

Access the purchase info:

    parser.purchaseInfo

##Getting Started

This is just a stand alone project for now. You should replace the receipt file with your own to test it. 

`isReceiptValidForDevice:` returns a BOOL if the receipt data is valid and accessing `purchaseInfo` will create an `RTKPurchaseInformation` object.
The properties of this object can be used to query the receipt and any in-app purchases (IAP).

Let me know any issues or questions; richard@empiricalmagic.com or [@rjstelling](http://twitter.com/rjstelling)

##OpenSSL

**WARNING**: You _must_ compile your own versions of libssl and libcrypto. 

##Known Issues

- Will not run under 64-bit Simulator in Xcode 5. Missing OpenSSL symbols. 

##Creating Your Own Demo App

In App Purchases (IPA) are tied to an apps bundle identifier and need to be set up on [iTunes Connect](https://itunesconnect.apple.com). In addition you cannot user the Simulator to test the purchase and receipt refresh. The only real way to test IAP is to set up an app of your own. 

###Creating Test Users

While developing your app any IAP will be performed with in the `[Sandbox]`. Conection to the sandbox is handled automaticly when you app it complied with a development provisioning profile. 

![iTunes Connect Dashboard](/docs/itunes-dash.png)

Log into iThues Connect and click on the "Manage Users" link.

![Manage User - iTunes Connect](/docs/itunes-test-user.png)

Click on the "Test User" button.

![Test Users](/docs/itunes-add-user.png)

Click on the "Add User" button in the top right.

![Add New User](/docs/add-new-user.png)

Fill in the "Add New User" form, the password requirements are the same as for the production store.

![Log Out, On Device](/docs/log-out-on-device.png)

On the device you will be testing with you _must_ log out of the App Store. This can be done in `Setting.app > iTunes & App Store`, tap the `Apple ID` and then `Sign Out`.

**DO NOT** sign in with the newly created test user. We will sign in from within the ReceiptKit test app.

###Create In App Purchase

![ReceiptKit App](/docs/ReceiptKit.png)

Either create an app for testing ReceiptKit or from with in the app you intend to incorporate ReceiptKit into, click the "Manage In App Purchases" button.

![Create New IAP](/docs/create-new.png)

![In App Purchases](/docs/iap.png)

If you want to use ReceiptKit demo app then you need to create 2 IAP called `consumable01` and `nonconsumable01`. You can give these any display name, cost and description as you like but "Product IDs" neewd to be; `consumable01` and `nonconsumable01`.

###Compiling ReceiptKit Demo App

1. Remember to change the bundle identifer to match that of the app you have created
2. Sign out of the App Store (see above) on your test device
3. Create a test user (if you have not already, see above)
4. Run the app on the test device
5. If you have set up the IAP correctly the display names, cost and description will be loaded into the app
6. Tapping a button next to an IAP will prompt you to sign in:
-- ![Sign in](/docs/sign-in.png)
7. Tap "Use Existing Apple ID" and enter the email and password of the test user set up above
-- ![Apple ID](/docs/apple-id.png)
8. If all is working the App will ask you to confirm the purchase (in Sandbox mode)
-- ![Confirm IAP](/docs/confirm-purchase.png)
9. If no errors occur you can tap "Check Receipt" to validate the receipt (you can only do this once per session unless you compile your own version of OpenSSL).
10. Tap "View Receipt" to see some info about the receipt.

### Got-Yas

1. If you create a consumable IAP this wil be removed form the receipt if you refresh the receipt. 

---

[Contact](https://agent-mailbox.richardstelling.com/#contact)
