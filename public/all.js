var app = angular.module('MyAnalytics', []);
app.controller('getTopUrls', function($scope, $http) {
    $http.get('http://localhost:3000/top_urls.json')
      .then(function(result){
        $scope.reports = result.data;
      })
});

app.controller('getTopReferrers', function($scope, $http) {
    $http.get('http://localhost:3000/top_referrers.json')
      .then(function(result){
        $scope.reports = result.data;
        console.log(result.data)
      })
});