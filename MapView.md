
# MapView Screen

### Story: User launch app to see their saved places on map.
================================================


### Narrative #1

```
As an  user
I want the app to automatically load all my saved places on map.
So I can always see the places with imagination of location in mind.
```

### Secenarios (Acceptance criteria)

```
Regardless of connectivity
 User should be able to see their saved places on map.
 Then the app should display all the places that being saved previously.
```

```
User is able to save images, videos, notes for a place they want to. 
```
================================================


## USE CASE

### Load Places From Persistent Storage Use Case

#### Data:
- N.A

#### Primary Course (Happy Path)
1. Execute "Load Places" command.
2. System fetch data from persistent storage.
3. System convert data to view model.
4. System displays data on map.

#### Retrieval error course (Sad Path)
1. System delivers error.

#### Invalid Data - Error Path (Sad Path)
1. System delivers invalid data error.

#### Empty data course (Sad Path)
1. System delivers no places.
================================================


### Load Place's Images From FileSystem Use Case

#### Data:
- N.A

#### Primary course (happy path):
1. Execute "Load Images" command.
2. System retrieves images from the FileSystem.
3. System delivers images.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers no image.


Consideration:
- Image size should not be too large, thus it saves user's local storage.
- Images can be compress before saving to storage.
- High level user type can save more imges on a single places.
================================================


### Load Place's Videos From FileSystem Use Case

#### Data:
- N.A

#### Primary course (happy path):
1. Execute "Load Videos" command.
2. System retrieves videos from the FileSystem.
3. System delivers videos.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers no video.


Consideration:
- Video should not be too long, thus it saves user's local storage.
- Videos can be compress before saving to storage.
- High level user type can save more videos on a single places.
================================================


### Save A Place Use Case

#### Data:
- Place


#### Primary Course (Happy Path)
1. Execute "Save Place" command.
2. System encodes data.
3. System saves new place data.
4. System delivers success messages.

#### Saving error course (Sad Path)
1. System delivers error.
================================================


### Delete A Place Use Case

#### Data:
- placeID


#### Primary Course (Happy Path)
1. Execute "Delete Place" command.
3. System delete place data from persistent storage.
4. System delivers success messages.

#### Saving error course (Sad Path)
1. System delivers error.
================================================

## Architecture

## Model Specs

### Place

| Propety               |Type                  |
|-----------------------|----------------------|
| `id`                  | `UUID`               |
| `name`                | `String` (optional)  |
| `latitude`            | `Double`             |
| `longitude`           | `Double`             |
| `savedTimestamp`      | `Date`               | Represent the time that user add new place and being automatically save to persistent.
| `imagesPath`          | `String`             |
| `videosPath`          | `String`             |
| `note`                | `String`             |
