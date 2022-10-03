# Test Assignment

This project was written in [Flutter Framework](http://flutter.dev "Flutter Framework") as test
assignment. The app is acting as [COCO explorer](https://cocodataset.org/#explore "COCO explorer")
port for mobile devices, capable to fetch images and draw segmentations over each one for every
object in the image.

![demo](https://user-images.githubusercontent.com/50031998/193664741-e69a18f0-0cf6-4796-ab08-e3d02c587b4f.gif)


## Getting started

This Application is using the native COCO dataset API. The state is managed
using [flutter_bloc](https://pub.dev/packages/flutter_bloc) pattern. Each model is generated
by [freezed](https://pub.dev/packages/freezed)
and [json_serializable](https://pub.dev/packages/json_serializable).

To build the app you should check the requirements below:

- Flutter v3 or above
- Computer with Windows, Linux or macOS operating system
- Network connection

## Table content

- [Build](#build)
- [Test](#test)
- [Generate documentations](#generate documentations)
- [Run](#run)
  <br/>

## Build

To build this app, first you have to let freezed and json_serializable generate the model files. So
that, we have a shell script which can do the entire build chain by itself, (only on macOS or Linux). just run
<pre>$     sudo chmod +x ./build.sh</pre>
enter your password
<pre>$     ./build.sh</pre>

## Test

This project contains flutter test files inside `/test` directory. so to perform all tests, just
type in your terminal:
<pre>$.    flutter test</pre>

and let it checking all the code logic.

## Generate documentations

To generate the documentation of this app, you have to run:
<pre>$.    flutter pub global activate dartdoc</pre>
<pre>$.    flutter pub global run dartdoc .</pre>

## Run

After checking the tests and generating the documentations to understand the base logic of the app,
we can run our app just by connecting your phone to your PC and typing:
<pre>$.    flutter run</pre>

<br/>
##Finally
In case of misunderstanding, mismatching with the test requirements or something missing, feel free to email me: [elleuch.amiirr@gmail.com](mailto:elleuch.amiirr@gmail.com).
Thank you.

## Credits

[Flutter](http://flutter.io): For this awesome framework.  
[COCO dataset](https://cocodataset.org): For providing the dataset.
