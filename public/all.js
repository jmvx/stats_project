var app = angular.module('MyAnalytics', []);
app.controller('getData', function($scope, $http) {
    $http.get('http://localhost:3000/top_urls.json')
      .then(function(result){
        $scope.reports = result.data;
      })
});