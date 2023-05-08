# Deep Learning: Artificial_Incoherence

Bálint Gergő (O78UXU), Medgyes Csaba (RF8I8P), Virsinger Dominika (RSABSD)

---
 
 ## Project:
The primary objective of this project is to utilize the UTKface dataset (available at https://www.kaggle.com/datasets/jangedoo/utkface-new?fbclid=IwAR0X1gR-ad1WuZH2QymWFyu_6ZIPmyj4m-9Y8H-5gn4f4kDD5BE8dm2xPJQ) in order to predict the age, gender, and race of individuals depicted in images. To accomplish this task, we developed a CNN model and applied transfer learning techniques using pretrained models, including Xcpetion and InceptionV3. Additionally, we aimed to implement the model into a mobile app after achieving satisfactory performance. Ultimately, our primary objective was to create a highly accurate model and visually represent the prediction process within a mobile app.

---

### Results: 
The results of InceptionV3 based model were:

| Variable	| Age	| Gender	| Race |
| --- |	--- | --- |	--- |
| Accuracy	| -	| 0.8307 |	0.9239 |
| F1	| - |	0.9191	| 0.7110 |
| Precision	| - |	0.9272	| - |
| Recall	| - |	0.9112 |	- |
| AUC	| - |	0.9783 |	- |
| RMSE	| 8.70	| -	 | - |

---
  
 ## Files:
**deeplearning_artificial_incoherence.ipynb** is the notebook for the first milestone.

**deeplearning_artificial_incoherence2.ipynb** is the notebook for the second milestone (this includes the model training and evaluation).

**deeplearning_artificial_incoherence_final.ipynb** is the notebook for the final submission. This has our whole data preparation, modeling, evaluation, hyperparameter optimization code. This notebook includes a lot of comments and explanation. For running the codes there are comments in this notebook with every important information.

**mobile_app folder** contains the Flutter project with the source code inside. Working application will be presented on the exam with physical mobile device.

**server_app folder** contains the source code of the Flask web API. It will be deployed on AWS EC2 instance.

**documentation folder** contains our documentation as a pdf file, and the zip file contains the .tex code.
  
Please note that in our code, we utilized Google Drive for storing our files. Throughout the process, we saved various variables (such as X_train and X_test) to files on Drive to avoid running the entire code from scratch each time. Unfortunately, these files are too large to upload here, but we can grant you access to them on Drive. Additionally, we downloaded and unzipped the UTKface dataset before uploading it to Drive and loading the data from there. You can find the link to our Drive repository containing the data at https://drive.google.com/drive/folders/1nQd8xP1kmc9ilUf_cSv8mgk4M9D-Nx8S?usp=share_link. If you wish to run the code, you may need to modify the file path to read the files from Drive.
