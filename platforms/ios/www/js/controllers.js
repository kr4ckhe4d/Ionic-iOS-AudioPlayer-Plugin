angular.module('starter.controllers', [])

.controller('DashCtrl', function($scope,$ionicLoading) {
            
            $scope.show = function() {
            $ionicLoading.show({
                               template: 'Loading...'
                               }).then(function(){
                                       console.log("The loading indicator is now displayed");
                                       });
            };
            $scope.hide = function(){
            $ionicLoading.hide().then(function(){
                                      console.log("The loading indicator is now hidden");
                                      });
            };
            
            
            
            $scope.$on('$ionicView.enter', function(){
                       // Any thing you can think of
                       //alert("This function just ran away");
                      // $scope.show();
            $scope.lol = [{
                          "title":"The A Team",
                          "id":"6620622103407453255",
                          "duration":261.093,
                          "path":"ipod-library://item/item.mp3?id=6620622103407453255",
                          "artist":"Ed Sheeran"
                          }];
            $scope.images = [];
            console.log("before enter");
            setTimeout(function() { $scope.listSongs(); }, 5);
            
            });
            
            $scope.listSongs = function(){
            //alert("list songs");
            window.cordova.plugins.AudioLibrary.getItems(function(items) {
                                                         $scope.lol = items.slice();
                                                         $scope.$apply();
                                                         });
            };
            
            $scope.queueAndPlay = function(index){
            //console.log($scope.lol[index].id);
            window.cordova.plugins.AudioLibrary.initQueue($scope.lol[index].id,
                                                          function(res) {
                                                          // playing queue is initialized, call #play to start playing from the first song.
                                                          console.log("Queued.. "+res);
                                                          });
            };
            
//            $scope.initializeQueue = function(){
//            window.cordova.plugins.AudioLibrary.initQueue(items[0].id, function() {
//                                                          // playing queue is initialized, call #play to start playing from the first song.
//                                                          console.log("Queued..");
//
//                                                          });
//            };
            
            $scope.play = function(){
            window.cordova.plugins.AudioLibrary.play(function() {
                                                     // first song in audio queue is now playing.
                                                     console.log("Playing..");
                                                     });
            };
            
            $scope.pause = function(){
            window.cordova.plugins.AudioLibrary.pause(function() {
                                                      // song is paused.
                                                      });
            }
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
