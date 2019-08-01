

OverView

This app would communicate to other devices (which all have this app installed in them) and show the list of all the devices nearby. Before this step, user has to perform small registeration process by entering his/her username and selecting color (optional). After all the devices are shown, user can select any device which would take them to next screen for chatting. In this screen, user can send and receive message from other device....:)

Cases in which this app would not work are as follows :-

(1.) This app do not support background modes
(2.) If app is not installed in any other device. In this case, it would not able to scan the devices with particular service for which our device is observing.
(3.) If user is trying to connect using Android device.


Some points worth noting :-

(1.) This app would work as both "central" and "peripheral" to other device as each device is required to send and receive message.

(2.) Since we are observing only services related to our app, hence, devices with this app installed would be shown in a device listing screen. If you want to see all the device in a screen :-

    Go to Utilities -> BluetoothInputOutput -> BluetoothConfigurator.swift

Open this file go to line 220 and change line to 

    centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])

and change line number 230 to

    peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:nil, CBAdvertisementDataLocalNameKey: advertisementData])

This would show all the active BLE devices around our device. Also, a device can have multiple service so, for each service it would be advertising a different data. If you want to see a single device for all the service, then you can set
CBCentralManagerScanOptionAllowDuplicatesKey : false or don't give any option. This would converge all the services of a device into single device. 


NOTE :- Above things are not suggested by Apple to do since it would adversely affect the device battery performance.
Also, we would not get to know the service which we are trying to access (In this case, Chat) from our device.

Installation/Build Process and Requirements :-

NOTE:-  This app can't be tested on simulator as Apple currently do not support Bluetooth functionality through simulator. We would be needing at least 2 device to test this app.

(1.) This project requires Xcode 10 to be installed in a Mac machine. For running app in a device, device should have minimum  iOS 11 installed in it.

(2.) Change the bundle identifier by going into BLEDemo project file Select BLEDemo Target -> General.

You can see bundle Identifier over here. For getting bundle identifier, you have to login with Apple developer account by going into Menu bar -> Xcode -> Preferences -> Account. Then click on "+" icon at the bottom left corner and add your apple developer credentials over here. Now, come back to Bundle Identifier part, and change it to something in this format :- 
                            com.TeamName.AppName
                            
(3.) Select Automatic Signing Option below bundle in Signing Section below bundle identifier section. This would automatically generate the provisioning profiles for your team.

(4.) Now connect your device and at the top bar of Xcode, you can see BLEDemo Target selected. Beside this, the device name is being displayed. When you will click on this device it would show you a list of all the device and simulator available currently to run your app. Go at the top of the listing and you can see your connected device over here. Select this device and click on run icon. This would run your app on a device.

(5.) Now repeat the same with other device and start using the app.

Enjoy using this app! Thanks.

