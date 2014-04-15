Collection+JSON Client for AngularJS
=====================================

Documentation will be finished once the API is solidified.

Features
--------

* Simple API
* Browser compatible(IE 8+)
* Ties into AngularJS $q promises
* Query/Template building


Example
-------

```js
var cj = $injector.get('cj');

// Start at the root of our api
cj("http://example.com").then(function(collection){

  // We get back a collection object
  // Let's follow the 'users' link
  collection.link('users').follow().then(function(collection){

    // Print out the current users
    console.log(collection.items());

    // Lets get a list of addresses from the first user we got back
    collection.items()[0].link('addresses').follow().then(function(collection){

      // Let's add a new address from the template
      var template = collection.template();
      template.set('street', '123 Fake Street');

      // Submit our new template
      template.submit().then(function(collection){
          console.log("Added a new address!!!");
      }, function(error){
          console.log("Something went wrong");
      });
    });
  });
});
```
