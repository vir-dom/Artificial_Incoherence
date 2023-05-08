#Deep Learning: Artificial_Incoherence
---
Bálint Gergő (O78UXU), Medgyes Csaba (RF8I8P), Virsinger Dominika (RSABSD)
--- 

 
 ## Project:
  The aim of the project is to predict the age, gender and race of people on pictures.
  Our dataset is the UTKface dataset (https://www.kaggle.com/datasets/jangedoo/utkface-new?fbclid=IwAR0X1gR-ad1WuZH2QymWFyu_6ZIPmyj4m-9Y8H-5gn4f4kDD5BE8dm2xPJQ).
  We made a CNN model, and also used transfer learning with some pretrained models (Xcpetion, InceptionV3)
  
  Optionail aims:
  When we made a modell with good enough performance, we implemented it to a mobile app.
  
  So our main goal was to make a very good model and visualize the prediction process in a mobile app.
  
 ## Files:
  <li>deeplearning_artificial_incoherence.ipynb is the notebook for the first milestone
  <li>deeplearning_artificial_incoherence2.ipynb is the notebook for the second milestone (this includes the model training and evaluation)
  <li>deeplearning_artificial_incoherence_final.ipynb is the notebook for the final submission. This has our whole data preparation, modeling, evaluation, hyperparameter optimization code. This notebook includes a lot of comments and explanation. For running the codes there are comments in this notebook with every important information.
  <li> mobile_app folder contains the Flutter project with the source code inside. Working application will be presented on the exam with physical mobile device
  <li> server_app folder contains the source code of the Flask web API. It will be deployed on AWS EC2 instance.
  <li> documentation folder contains our documentation as a pdf file, and the zip file contains the .tex code
  
  (Note: in the code, we used Google Drive as storage for our files. There are many steps where we saved some variables (X_train, X_test, ...)
   into a file on Drive, so that we do not have to run the code from the beginning every time. These files are too big to upload here, but we can share those on Drive      with you. Also, the UTKface dataset was first downloaded, unzipped and then uploaded to Drive, and we loaded the data from there.)
   The link to our Drive repository with the data: https://drive.google.com/drive/folders/1nQd8xP1kmc9ilUf_cSv8mgk4M9D-Nx8S?usp=share_link
   If you want to run the codes, you might need to change the path to be able to read the files from Drive.)
