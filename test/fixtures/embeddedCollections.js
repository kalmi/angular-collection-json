angular.module('Collection').service('cjEmbedded',function(){
  'use strict';
  var original = {
    "collection": {
      "version": "1.0",
      "href": "/characters.json",
      "embedded": [
        {
        "collection": {
          "version": "1.0",
          "href": "/characters/the_doctor/actors.json",
          "items": [
            {
            "href": "/doctors/1.json",
            "data": [
              {
              "name": "full-name",
              "value": "William Hartnell"
            }
            ]
          },
          {
            "href": "/doctors/2.json",
            "data": [
              {
              "name": "full-name",
              "value": "Patrick Troughton"
            }
            ]
          },
          {
            "href": "/doctors/3.json",
            "data": [
              {
              "name": "full-name",
              "value": "Jon Pertwee"
            }
            ]
          },
          {
            "href": "/doctors/4.json",
            "data": [
              {
              "name": "full-name",
              "value": "Tom Baker"
            }
            ]
          }
          ]
        }
      }
      ],
      "items": [
        {
        "href": "/characters/the_doctor.json",
        "links": [
          {
          "href": "/characters/the_doctor/actors.json",
          "rel": "actors",
          "render": "link",
          "prompt": "Actors"
        }
        ]
      }
      ],
      "links": [
        {
          "href": "/characters/the_doctor/actors.json",
          "rel": "root_actors",
          "render": "link",
          "prompt": "Actors"
        }
      ]
    }
  };

  return JSON.parse(JSON.stringify(original));
});
