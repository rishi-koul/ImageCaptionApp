# ImageCaptionApp

## Description
* An app developed using `Flutter` to generate image captions.
* The caption generated are then converted to voice for the use of blind people
* Uses a restructed `VGG16()` model for image recognition and `Natural Language Processing` for generating captions.
* A Python Flask backend is used to load the trained machine learning model and provide the result in json format to the Flutter frontend
* Google Firestore Storage is used as an intermidiate to store the images that are taken are later are used in the backend to generate captions

---
## UI Design

<img width="350" alt="Screen Shot 2020-07-29 at 8 06 15 PM" src="https://user-images.githubusercontent.com/59619895/88865839-f90ff300-d1d6-11ea-968f-07fbba626388.png">

---

### Notes

Please refer to specific `README.md` files of each component in `src` folder for further details.







