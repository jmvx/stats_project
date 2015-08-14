var app = angular.module('MyAnalytics', []);

app.controller('getTopUrls', function($scope, $http) {
    $http.get('/top_urls.json')
      .then(function(result){
        $scope.reports = result.data;
      })
});

app.controller('getTopReferrers', function($scope, $http) {
    $http.get('/top_referrers.json')
      .then(function(result){
        $scope.reports = result.data;
      })
});