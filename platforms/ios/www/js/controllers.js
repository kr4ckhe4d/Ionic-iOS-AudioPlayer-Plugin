angular.module('starter.controllers', [])

.controller('DashCtrl', function($scope) {
            
            $scope.lol = [{
                          "title":"The A Team",
                          "id":"6620622103407453255",
                          "duration":261.093,
                          "path":"ipod-library://item/item.mp3?id=6620622103407453255",
                          "artist":"Ed Sheeran"
                          },
                          {
                          "title":"Aicha",
                          "id":"6620622103407453281",
                          "duration":256.496,
                          "path":"ipod-library://item/item.mp3?id=6620622103407453281",
                          "artist":"Khaled"
                          },
                          {  
                          "title":"All My Friends (feat. Tinashe & Chance The Rapper)",
                          "id":"4992972861530656772",
                          "duration":229.799,
                          "path":"ipod-library://item/item.mp3?id=4992972861530656772",
                          "artist":"SNAKEHIPS"
                          }];
            $scope.images = [];
            
            $scope.listSongs = function(){
            window.cordova.plugins.AudioLibrary.getItems(function(items) {
                                                         console.log(items[0]);
                                                         
//                                                         for(var i=0;i<items.length;i++){
//                                                         $scope.lol.push(items[i]);
//                                                         
//                                                         var image = new Image();
//                                                         image.src = 'data:image/png;base64,'+items[i].image;
//                                                         
//                                                         $scope.images.push(image);
//                                                         $scope.$apply();
//                                                         }
                                                         $scope.lol = items.slice();
                                                         $scope.$apply();
                                                         
                                                         //console.log($scope.lol);
                                                         //var image = new Image();
                                                         //image.src = 'data:image/png;base64,'+items[0].image;
                                                         
                                                         //$scope.array.push(image);
                                                         
                                                         //$scope.array.push(image);
                                                         //document.body.appendChild(image);
                                                         
                                                         //document.getElementById('image').appendChild(image);
                                                         
                                                         window.cordova.plugins.AudioLibrary.initQueue(items[0].id, function() {
                                                                                                       // playing queue is initialized, call #play to start playing from the first song.
                                                                                                       console.log("Queued..");
                                                                                                       
                                                                                                       });
                                                         });
            };
            
            $scope.initializeQueue = function(){
            window.cordova.plugins.AudioLibrary.initQueue(items[0].id, function() {
                                                          // playing queue is initialized, call #play to start playing from the first song.
                                                          console.log("Queued..");

                                                          });
            };
            
            $scope.play = function(){
            window.cordova.plugins.AudioLibrary.play(function() {
                                                     // first song in audio queue is now playing.
                                                     console.log("Playing..");
                                                     });
            };
})

.controller('ChatsCtrl', function($scope, Chats) {
  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //
  //$scope.$on('$ionicView.enter', function(e) {
  //});

  $scope.chats = Chats.all();
  $scope.remove = function(chat) {
    Chats.remove(chat);
  };
})

.controller('ChatDetailCtrl', function($scope, $stateParams, Chats) {
  $scope.chat = Chats.get($stateParams.chatId);
})

.controller('AccountCtrl', function($scope) {
  $scope.settings = {
    enableFriends: true
  };
});
