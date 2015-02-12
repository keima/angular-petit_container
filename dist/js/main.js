'use strict';

angular.module("MyApp", ["ngMaterial", "restangular"])
  .constant('BaseUrl', 'https://arcane-harbor-6152.herokuapp.com')
  //.constant('BaseUrl', 'http://localhost:5000')
  .config(function (RestangularProvider, BaseUrl) {
    RestangularProvider.setBaseUrl(BaseUrl + "/api");
    RestangularProvider.setDefaultHttpFields({withCredentials: true});
  })
  .controller("MyCtrl", function ($http, Restangular, BaseUrl, $mdSidenav) {
    var self = this;

    // Variables
    this.isLogin = false;
    this.items = [];
    this.favedItems = [];
    this.loginPage = BaseUrl;

    // Initialize
    $http.get("json/items.json").success(function (data) {
      self.items = data;

      // TODO: use promise
      Restangular.all("store").all("favs").getList()
        .then(function (result) {
          self.favedItems = result;

          self.favedItems.forEach(function (favedItem) {
            self.items.forEach(function (item) {
              if (favedItem.id == item.id) {
                item.isFaved = true;
              }
            });
          });
        });

    });

    Restangular.all("is_logged_in").getList()
      .then(function(){
        // success
        self.isLogin = true;
      }, function() {
        // fail
        self.isLogin = false;
      });


    // Method
    this.setFavs = function (index) {
      var isAlreadyFaved = false;
      var item = self.items[index];

      if (_.isUndefined(item)) {
        console.log("Error! item is undefined.");
        return;
      }

      // breakしたいので古典的に書く
      for (var i = 0; i < self.favedItems.length; i++) {
        if (item.id == self.favedItems[i].id) {
          item.isFaved = false;
          self.favedItems.splice(i, 1);
          isAlreadyFaved = true;
          break;
        }
      }

      if (!isAlreadyFaved) {
        self.favedItems.push(item);
        item.isFaved = true;
      }

      Restangular.all("store").all("favs").post(self.favedItems)
        .then(function (result) {
          console.log(result);
        });
    }

  })
;