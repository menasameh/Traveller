## Traveller app
shows you the popular flight offers to different destinations using Kiwi API 

### Project specs
- Xcode version 12.4
- Cocoapods version 1.10.1

### Dependincies 
- Alamofire version 5.2, [Github](https://github.com/Alamofire/Alamofire)
- AlamofireImage version 4.1, [Github](https://github.com/Alamofire/AlamofireImage)

### Running the app
- Clone the repo
- Run `pod install` inside the repo folder
- Run `Traveller.xcworkspace` 

### API configuration
- First I was using skypicker api but I notced that the docs says we highly recommend using tequila.kiwi.com
- So I have upgraded the network layer to use tequila.kiwi.com


### API key
- You will need to create an account in Tequila portal [here](https://tequila.kiwi.com/portal/login/register)
- Then you need to create a solution [here](https://tequila.kiwi.com/portal/my-solutions)
- After visiting that solution you just created, in the `Details` section you would find the API key to use
- you will need to create a Config file nammed `Config.xcconfig` in Traveller/Commons/Config.xcconfig
- And add your API key in that file `API_KEY = xxx`
- this file is local and won't be stored in the git repo, ignored in the `.gitignore` file

### Screenshots
#### Popular flights flow
![splash-screen](screenshots/splash-screen.png) ![home-screen](screenshots/home-screen.png) ![loading](screenshots/loading.png) ![popular-flights-screen-normal](screenshots/popular-flights-screen-normal.png)

#### Popular flights screen different states
Loading
![loading](screenshots/loading.png) 
Normal flights loaded
![popular-flights-screen-normal](screenshots/popular-flights-screen-normal.png)
Empty flights response
![popular-flights-screen-empty](screenshots/popular-flights-screen-empty.png)
API errors
![error-api](screenshots/error-api-1.png) ![error-api](screenshots/error-api-2.png) ![error-api](screenshots/error-api-3.png)
Location errors
![error-location](screenshots/error-location-1.png) ![error-location](screenshots/error-location-2.png) ![error-location](screenshots/error-location-3.png) 
#### Auth flow [not implemented just UI]
![auth-flow](screenshots/auth-keyboard.png) ![auth-flow](screenshots/auth-mail.png) ![auth-flow](screenshots/auth-pass.png) 
